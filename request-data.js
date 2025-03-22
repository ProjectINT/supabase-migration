
// request-data.js
import sql from './db.js';
/*
  Это падает. Для 3000 пользователей не возможно вернуть все данные за раз.

*/
async function getUsersOver() {
  const users = await sql`
    SELECT id FROM users
  `

  console.log('users', users);
  
  return users
}

const usersData = await getUsersOver();

usersData.forEach(async (user) => {

  console.log('user.id', user.id);
  const orders = await sql`
    SELECT * FROM orders WHERE user_id = ${user.id} LIMIT 15
  `;

  console.log('orders', orders.length);
})

