import { readFile } from 'node:fs/promises';
import { cert, initializeApp } from 'firebase-admin/app';
import { FieldPath, FieldValue, getFirestore } from 'firebase-admin/firestore';

const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!credentialsPath) {
  console.error(
    'GOOGLE_APPLICATION_CREDENTIALS doit pointer vers un fichier de compte de service Firebase.',
  );
  process.exit(1);
}

const dryRun = process.env.DRY_RUN === 'true';
const pageSize = 500;
const serviceAccount = JSON.parse(await readFile(credentialsPath, 'utf8'));

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

let lastId;
let scanned = 0;
let migrated = 0;
let skipped = 0;
let failed = 0;

for (;;) {
  let query = db
    .collection('users')
    .orderBy(FieldPath.documentId())
    .limit(pageSize);
  if (lastId) {
    query = query.startAfter(lastId);
  }

  const snapshot = await query.get();
  if (snapshot.empty) {
    break;
  }

  for (const document of snapshot.docs) {
    scanned += 1;
    const legacyEmail = document.get('email');

    if (typeof legacyEmail !== 'string' || legacyEmail.trim().length === 0) {
      skipped += 1;
      continue;
    }

    if (dryRun) {
      migrated += 1;
      console.log(`[dry-run] ${document.id}`);
      continue;
    }

    try {
      await db.runTransaction(async (transaction) => {
        const fresh = await transaction.get(document.ref);
        if (!fresh.exists) {
          return;
        }

        const data = fresh.data() ?? {};
        if (!Object.hasOwn(data, 'email')) {
          return;
        }

        const privateRef = db.collection('users_private').doc(fresh.id);
        const privateSnapshot = await transaction.get(privateRef);
        if (!privateSnapshot.exists) {
          transaction.set(privateRef, {
            id: fresh.id,
            email: String(data.email).trim().toLowerCase(),
            creeLe: FieldValue.serverTimestamp(),
          });
        }

        transaction.update(fresh.ref, { email: FieldValue.delete() });
      });
      migrated += 1;
    } catch (error) {
      failed += 1;
      console.error(`Échec pour ${document.id}: ${error.message}`);
    }
  }

  lastId = snapshot.docs[snapshot.docs.length - 1].id;
}

console.log(
  JSON.stringify({ scanned, migrated, skipped, failed, dryRun }, null, 2),
);

if (failed > 0) {
  process.exitCode = 1;
}
