
// request-data.js
import sql from './db.js';

/*
  Это падает. Для 3000 пользователей не возможно вернуть все данные за раз.

  Очень не понятно, то зависает то с ошибкой падает.
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

usersData.forEach(async (user) => {
  // Check input data
  if (!hasNullByte(user.id)) {
    console.log('user.id', user.id);
  }

  try {
    const orders = await sql`
      SELECT * FROM orders WHERE user_id = ${user.id} LIMIT 15;
    `;
    console.log('orders', orders.length);
  } catch (error) {
    console.error('Error', error);
  }
})

