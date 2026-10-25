import { readFileSync } from 'node:fs';
import { test, before, after } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  addDoc,
  collection,
  doc,
  getDoc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const rules = readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8');
const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080';
const [host, port] = emulatorHost.split(':');

let env;
let alice;
let bob;
let charlie;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-solink',
    firestore: { rules, host, port: Number(port) },
  });
  alice = env.authenticatedContext('alice').firestore();
  bob = env.authenticatedContext('bob').firestore();
  charlie = env.authenticatedContext('charlie').firestore();
});

after(async () => {
  await env?.cleanup();
});

const publicUser = (uid) => ({
  id: uid,
  nom: 'Nom',
  prenom: 'Prénom',
  bio: '',
  posts: 0,
  followers: 0,
  followings: 0,
  creeLe: serverTimestamp(),
});

test('profil public : création par le propriétaire uniquement', async () => {
  await assertSucceeds(setDoc(doc(alice, 'users', 'alice'), publicUser('alice')));
  await assertFails(setDoc(doc(bob, 'users', 'alice'), publicUser('alice')));
});

test('e-mail privé : lecture réservée au propriétaire', async () => {
  await assertSucceeds(
    setDoc(doc(alice, 'users_private', 'alice'), {
      id: 'alice',
      email: 'alice@example.com',
      creeLe: serverTimestamp(),
    }),
  );
  await assertSucceeds(getDoc(doc(alice, 'users_private', 'alice')));
  await assertFails(getDoc(doc(bob, 'users_private', 'alice')));
});

test('likes : union limitée à son propre UID', async () => {
  await assertSucceeds(
    setDoc(doc(alice, 'posts', 'post-1'), {
      id: 'post-1',
      userId: 'alice',
      userName: 'Alice',
      content: 'Bonjour',
      likes: [],
      comments: 0,
      creeLe: serverTimestamp(),
    }),
  );
  await assertSucceeds(
    updateDoc(doc(bob, 'posts', 'post-1'), {
      likes: ['bob'],
    }),
  );
  await assertFails(
    updateDoc(doc(charlie, 'posts', 'post-1'), {
      likes: ['charlie'],
    }),
  );
});

test('commentaire : incrément du compteur de 1', async () => {
  await assertSucceeds(
    setDoc(doc(alice, 'posts', 'post-1', 'comments', 'comment-1'), {
      id: 'comment-1',
      userId: 'alice',
      userName: 'Alice',
      content: 'Bravo',
      creeLe: serverTimestamp(),
    }),
  );
  await assertSucceeds(
    updateDoc(doc(bob, 'posts', 'post-1'), {
      comments: 1,
    }),
  );
  await assertFails(
    updateDoc(doc(charlie, 'posts', 'post-1'), {
      comments: 3,
    }),
  );
});

test('post : le contenu ne peut pas être modifié', async () => {
  await assertFails(
    updateDoc(doc(alice, 'posts', 'post-1'), {
      content: 'Contenu modifié',
    }),
  );
});

test('chat : messages réservés aux membres de la room', async () => {
  await assertSucceeds(
    setDoc(doc(alice, 'chatrooms', 'alice_bob'), {
      members: ['alice', 'bob'],
      lastMessage: 'Salut',
      envoyeLe: serverTimestamp(),
    }),
  );
  await assertSucceeds(
    addDoc(collection(alice, 'chatrooms', 'alice_bob', 'messages'), {
      senderId: 'alice',
      content: 'Salut',
      envoyeLe: serverTimestamp(),
    }),
  );
  await assertFails(
    addDoc(collection(charlie, 'chatrooms', 'alice_bob', 'messages'), {
      senderId: 'charlie',
      content: 'Intrusion',
      envoyeLe: serverTimestamp(),
    }),
  );
});

test('migration : le propriétaire peut retirer email du profil public', async () => {
  const legacyCreatedAt = new Date('2025-01-01T00:00:00Z');
  await env.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'users', 'legacy'), {
      id: 'legacy',
      nom: 'Legacy',
      prenom: 'Compte',
      email: 'legacy@example.com',
      bio: 'Ancien profil',
      posts: 0,
      followers: 0,
      followings: 0,
      creeLe: legacyCreatedAt,
    });
  });

  const legacy = env.authenticatedContext('legacy').firestore();
  const publicRef = doc(legacy, 'users', 'legacy');
  const snapshot = await getDoc(publicRef);
  const data = snapshot.data();
  const { email, ...publicData } = data;

  await assertSucceeds(
    setDoc(doc(legacy, 'users_private', 'legacy'), {
      id: 'legacy',
      email,
      creeLe: serverTimestamp(),
    }),
  );
  await assertSucceeds(setDoc(publicRef, publicData));

  const migrated = await getDoc(publicRef);
  if ('email' in migrated.data()) {
    throw new Error('email encore présent dans le profil public');
  }
});
