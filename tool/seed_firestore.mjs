/**
 * Seed de donnees simulees pour l'emulateur Firestore local.
 *
 * Usage :
 *   node seed_firestore.mjs [--users=10] [--posts=30] [--comments-per-post=2]
 *                           [--password=SolinkTest123] [--keep]
 *
 * Le script utilise firebase-admin (contourne les regles de securite) et cree :
 *   - des comptes Firebase Auth dans l'emulateur,
 *   - users/ et users_private/ (profils),
 *   - posts/ et posts/{id}/comments/,
 *   - chatrooms/ et chatrooms/{id}/messages/.
 *
 * L'emulateur doit tourner (voir README) :
 *   firebase emulators:start --only firestore,auth --project demo-solink
 *
 * Les identifiants affiches a la fin permettent de se connecter a l'application
 * avec un profil simule.
 */

import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import {
  FieldValue,
  Timestamp,
  getFirestore,
} from 'firebase-admin/firestore';

const args = process.argv.slice(2);

function readNumber(name, fallback) {
  const match = args.find((arg) => arg.startsWith(`--${name}=`));
  if (!match) {
    return fallback;
  }
  const value = Number(match.split('=')[1]);
  if (!Number.isFinite(value) || value < 0) {
    throw new Error(`--${name} doit etre un nombre positif ou nul.`);
  }
  return value;
}

function readString(name, fallback) {
  const match = args.find((arg) => arg.startsWith(`--${name}=`));
  return match ? match.split('=').slice(1).join('=') : fallback;
}

const hasFlag = (name) => args.includes(`--${name}`);

const options = {
  userCount: readNumber('users', 10),
  postCount: readNumber('posts', 30),
  commentsPerPost: readNumber('comments-per-post', 2),
  password: readString('password', 'SolinkTest123'),
  keepExisting: hasFlag('keep'),
  simpleEmails: hasFlag('simple-emails'),
};

const projectId = readString('project', 'demo-solink');
const host = readString('host', '127.0.0.1');
const authPort = Number(readString('auth-port', '9099'));
const firestorePort = Number(readString('firestore-port', '8080'));

// ---------------------------------------------------------------------------
// Connexion a l'emulateur
// ---------------------------------------------------------------------------

initializeApp({ projectId });

const db = getFirestore();
db.settings({ host: `${host}:${firestorePort}`, ssl: false });

// L'API Auth de firebase-admin ne dispose pas de `useEmulator` : l'emulateur
// est detecte via la variable d'environnement officielle.
process.env.FIREBASE_AUTH_EMULATOR_HOST = `${host}:${authPort}`;

const auth = getAuth();

// ---------------------------------------------------------------------------
// Contenu simule
// ---------------------------------------------------------------------------

const FIRST_NAMES = [
  'Awa', 'Koffi', 'Fatou', 'Yao', 'Adjoua', 'Kofi', 'Akissi', 'Yannick',
  'Nadia', 'Serge', 'Mariam', 'Ibrahim', 'Chantal', 'Kwame', 'Estelle',
  'Antoine', 'Blandine', 'Rodrigue', 'Solange', 'Prosper',
];

const LAST_NAMES = [
  'Koffi', 'Mensah', 'Adjo', 'Ndiaye', 'Traore', 'Ahoua', 'Zadi', 'Kouassi',
  'Diallo', 'Bamba', 'Sissoko', 'Doumbia', 'Coulibaly', 'Gnagne', 'Yapi',
];

const BIOS = [
  'Passionne de photo et de cuisine.',
  'Dev front-end, cafe a la main.',
  'Je partage mes lectures du mois.',
  'Cafe, marche et debat.',
  'Fan de voyage au cameroun.',
  'J-ecris des histoires courtes.',
  'Sport, cuisine et un peu de code.',
  'Toujours en train d apprendre.',
];

const POSTS = [
  'Cafe a 6h du matin, le calme absolu avant la journee.',
  'Nouveau restaurant ouvre dans le quartier, vous y etes alle ?',
  'Petit conseil : commencez la journee par une lecture de dix minutes.',
  'La plage est magnifique aujourd hui, beaucoup de photos.',
  'J ai enfin fini ce projet, trois mois de travail.',
  'Recette de poulet yassa, la version de ma mere.',
  'Nouvelle serie recommandee, ambiance parfaite pour la nuit.',
  'Le marche du samedi est de retour, Mongo pour tout le monde.',
  'Pause cafe avec des amis, comme quoi la vie continue.',
  'J ai appris une nouvelle competence aujourd hui, je suis fier.',
  'Il fait enfin un peu frais, j ai survecu a l ete.',
  'On se retrouve au centre culturel samedi soir ?',
  'Ce livre m a fait reflechir pendant une semaine entiere.',
  'Petit voyage de trois jours, photos quand je rentre.',
  'Nouveau projet en tete, je vous tiens au courant.',
  'Le meilleur resto de la ville, aucun doute.',
  'Ce qui est simple est souvent ce qui est le plus difficile.',
  'Retour en ville apres une semaine de repos.',
  'J adore cette saison, les couleurs et les fruits.',
  'On devrait se retrouver plus souvent, c est decide.',
];

const COMMENTS = [
  'Totalement d accord !',
  'Merci pour le partage, interressant.',
  'C est ou exactement ?',
  'Je ne suis pas d accord mais c est un avis.',
  'Bravo, continue comme ca !',
  'Haha excellent.',
  'Tu as raison, j ai passe une bonne journee.',
  'J ai teste, ca marche vraiment.',
  'Pas mal, mais il y a mieux.',
  'On en reparle plus tard !',
];

const MESSAGES = [
  'Salut !',
  'Tu es dispo quand ?',
  'Je passe vers midi.',
  'Parfait, a toute.',
  'Merci beaucoup !',
  'Tu as vu le dernier message ?',
  'On se cale demain ?',
  'C est bon pour moi.',
];

/** Tirage pseudo-aleatoire deterministe : un meme seed donne le meme jeu. */
function createRandom(seed) {
  let state = seed >>> 0;
  return () => {
    state = (state * 1664525 + 1013904223) >>> 0;
    return state / 0x100000000;
  };
}

const random = createRandom(20240517);

const pick = (list) => list[Math.floor(random() * list.length)];

function randomInt(min, max) {
  return Math.floor(random() * (max - min + 1)) + min;
}

/** Timestamp anterieur aleatoire, en millisecondes. */
function pastTimestamp(maxDaysAgo = 90) {
  const daysAgo = random() * maxDaysAgo;
  return Timestamp.fromMillis(Date.now() - daysAgo * 24 * 60 * 60 * 1000);
}

// ---------------------------------------------------------------------------
// Nettoyage
// ---------------------------------------------------------------------------

async function clearCollection(path) {
  const snapshot = await db.collection(path).get();
  let count = 0;
  for (const document of snapshot.docs) {
    await document.ref.delete();
    count += 1;
  }
  return count;
}

/** Supprime les sous-collections (comments / messages) des documents parents. */
async function clearSubcollections(parentPath, subPath) {
  const snapshot = await db.collection(parentPath).get();
  let count = 0;
  for (const document of snapshot.docs) {
    const children = await document.ref.collection(subPath).get();
    for (const child of children.docs) {
      await child.ref.delete();
      count += 1;
    }
  }
  return count;
}

async function clearAuthUsers() {
  let count = 0;
  let page = await auth.listUsers(1000);
  while (page.users.length > 0) {
    for (const user of page.users) {
      try {
        await auth.deleteUser(user.uid);
        count += 1;
      } catch (error) {
        // Un compte deja supprime est ignore.
        if (error.code !== 'auth/user-not-found') {
          throw error;
        }
      }
    }
    page = await auth.listUsers(1000);
  }
  return count;
}

async function clearDatabase() {
  console.log('Nettoyage des donnees existantes...');
  const messages = await clearSubcollections('chatrooms', 'messages');
  const comments = await clearSubcollections('posts', 'comments');
  const posts = await clearCollection('posts');
  const rooms = await clearCollection('chatrooms');
  const users = await clearCollection('users');
  const privates = await clearCollection('users_private');
  const accounts = await clearAuthUsers();
  console.log(
    `Supprime : ${accounts} comptes Auth, ${users} users, ${privates} users_private, ` +
      `${posts} posts, ${comments} comments, ${rooms} chatrooms, ${messages} messages.`,
  );
}

// ---------------------------------------------------------------------------
// Generation
// ---------------------------------------------------------------------------

const users = [];

function buildUsers() {
  for (let index = 0; index < options.userCount; index += 1) {
    const prenom = FIRST_NAMES[index % FIRST_NAMES.length];
    const nom = LAST_NAMES[index % LAST_NAMES.length];
    // Les adresses « simples » facilitent la saisie manuelle sur un appareil :
    // le clavier Android complete automatiquement les adresses contenant un point.
    const email = options.simpleEmails
      ? `user${index + 1}@solink.test`
      : `${prenom.toLowerCase()}.${nom.toLowerCase()}${index + 1}@solink.test`;
    users.push({
      email,
      nom,
      prenom,
      bio: pick(BIOS),
      createdAt: pastTimestamp(120),
    });
  }
  return users;
}

async function createAuthAccounts() {
  console.log(`Creation de ${users.length} comptes Auth...`);
  for (const user of users) {
    const created = await auth.createUser({
      email: user.email,
      password: options.password,
      emailVerified: true,
      displayName: `${user.prenom} ${user.nom}`,
    });
    user.id = created.uid;
  }
}

async function writeUserDocuments() {
  console.log('Ecriture des profils users/ et users_private/...');
  const batch = db.batch();
  for (const user of users) {
    batch.set(db.collection('users').doc(user.id), {
      id: user.id,
      nom: user.nom,
      prenom: user.prenom,
      bio: user.bio,
      posts: 0,
      followers: 0,
      followings: 0,
      creeLe: user.createdAt,
    });
    batch.set(db.collection('users_private').doc(user.id), {
      id: user.id,
      email: user.email,
      creeLe: user.createdAt,
    });
  }
  await batch.commit();
}

async function writePosts() {
  console.log(`Ecriture de ${options.postCount} posts...`);
  const batch = db.batch();
  for (let index = 0; index < options.postCount; index += 1) {
    const author = pick(users);
    const id = `seed-post-${String(index + 1).padStart(4, '0')}`;
    batch.set(db.collection('posts').doc(id), {
      id,
      userId: author.id,
      userName: `${author.prenom} ${author.nom}`,
      content: pick(POSTS),
      comments: 0,
      likes: [],
      creeLe: pastTimestamp(90),
    });
  }
  await batch.commit();
}

async function writeCommentsAndLikes() {
  console.log('Ecriture des commentaires et des likes...');
  const posts = await db.collection('posts').get();

  const batch = db.batch();
  for (const post of posts.docs) {
    const data = post.data();
    const commentCount = randomInt(0, options.commentsPerPost);
    const likes = users
      .filter(() => random() < 0.35)
      .map((user) => user.id)
      .filter((id) => id !== data.userId)
      .slice(0, 20);

    for (let index = 0; index < commentCount; index += 1) {
      const author = pick(users);
      const commentId = `seed-comment-${index + 1}`;
      batch.set(post.ref.collection('comments').doc(commentId), {
        id: commentId,
        userId: author.id,
        userName: `${author.prenom} ${author.nom}`,
        content: pick(COMMENTS),
        creeLe: pastTimestamp(60),
      });
    }

    batch.update(post.ref, { comments: commentCount, likes });
  }
  await batch.commit();
}

async function writeChatRooms() {
  console.log('Ecriture des conversations...');
  const batch = db.batch();
  const roomCount = Math.min(users.length, 8);

  for (let index = 0; index < roomCount; index += 1) {
    const first = users[index];
    const second = users[(index + 1) % users.length];
    if (first.id === second.id) {
      continue;
    }

    const members = [first.id, second.id].sort();
    const roomId = members.join('_');
    const messages = [];

    const messageCount = randomInt(2, 6);
    for (let messageIndex = 0; messageIndex < messageCount; messageIndex += 1) {
      const sender = random() < 0.5 ? first : second;
      messages.push({
        id: `seed-message-${messageIndex + 1}`,
        senderId: sender.id,
        content: pick(MESSAGES),
        envoyeLe: pastTimestamp(30),
      });
    }

    const last = messages[messages.length - 1];
    batch.set(db.collection('chatrooms').doc(roomId), {
      members,
      lastMessage: last.content,
      envoyeLe: last.envoyeLe,
    });

    for (const message of messages) {
      batch.set(db.collection('chatrooms').doc(roomId).collection('messages').doc(message.id), {
        senderId: message.senderId,
        content: message.content,
        envoyeLe: message.envoyeLe,
      });
    }
  }
  await batch.commit();
}

async function syncUserCounters() {
  console.log('Synchronisation des compteurs posts/followers/followings...');
  const posts = await db.collection('posts').get();
  const counts = new Map();
  for (const post of posts.docs) {
    const userId = post.data().userId;
    counts.set(userId, (counts.get(userId) ?? 0) + 1);
  }

  const batch = db.batch();
  for (const user of users) {
    batch.update(db.collection('users').doc(user.id), {
      posts: counts.get(user.id) ?? 0,
      followers: randomInt(0, 25),
      followings: randomInt(0, 25),
    });
  }
  await batch.commit();
}

// ---------------------------------------------------------------------------
// Point d'entree
// ---------------------------------------------------------------------------

async function main() {
  if (options.userCount === 0) {
    throw new Error('--users doit etre superieur a zero.');
  }

  if (!options.keepExisting) {
    await clearDatabase();
  }

  buildUsers();
  await createAuthAccounts();
  await writeUserDocuments();
  await writePosts();
  await writeCommentsAndLikes();
  await writeChatRooms();
  await syncUserCounters();

  console.log('\nSeed termine. Comptes de test (mot de passe commun) :');
  for (const user of users) {
    console.log(
      `  ${user.email.padEnd(34)} | ${options.password} | ${user.prenom} ${user.nom}`,
    );
  }
  console.log(
    `\n${users.length} profils, ${options.postCount} posts, ` +
      `${options.commentsPerPost} commentaires max par post.`,
  );
}

main().catch((error) => {
  console.error(`\nEchec du seed : ${error.message}`);
  process.exitCode = 1;
});
