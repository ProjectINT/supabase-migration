
// request-data.js
import sql, { newPooller } from './db.js';

/*
  Это падает. Для 3000 пользователей не возможно вернуть все данные за раз.

  Очень не понятно, то зависает то с ошибкой падает.

  !!! Это падало соединение, pooller не может использоваться много раз.
  Нужно новый создавать. Приблизительно 15 запросов он обрабатывает и падает.

  Теперь работает:
*/

function hasNullByte(str) {
  return /\x00/.test(str);
}

async function getUsersOver() {
  const users = await sql`
    SELECT id FROM users LIMIT 300 OFFSET 300;
  `

  console.log('users', users.length);
  
  return users
}

const usersData = await getUsersOver();

Promise.all(usersData.map(async (user) => {
  // Check input data
  if (!hasNullByte(user.id)) {
    console.log('user.id', user.id);
  }

  const pooller = newPooller();

  try {
    const orders = await pooller`
      SELECT * FROM orders WHERE user_id = ${user.id} LIMIT 15;
    `;
    console.log('orders', orders.length);
  } catch (error) {
    console.error('Error', error);
  }
  pooller.end();
}))

