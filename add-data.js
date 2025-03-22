// request-data.js
import sql from './db.js';

// Конфигурация
const TOTAL_TENANTS = 300;
const USERS_PER_TENANT = 10;
const ORDERS_PER_TENANT = 2000;
const BATCH_SIZE = 500;

const products = ['Laptop', 'Phone', 'Tablet', 'Monitor', 'Keyboard'];
const getRandomProduct = () => products[Math.random() * products.length | 0];
const getRandomAmount = () => Math.random() * 9900 + 100;
const getRandomDate = () => new Date(Date.now() - Math.random() * 31536000000);

function chunk(array, size) {
  const result = [];
  for (let i = 0; i < array.length; i += size) {
    result.push(array.slice(i, i + size));
  }
  return result;
}

async function generateData() {
  try {
    // Генерация тенантов
    const tenants = Array.from({ length: TOTAL_TENANTS }, (_, i) =>
      `Company-${i + 1}-${Math.random().toString(36).slice(2, 6)}`
    );

    const insertedTenants = await sql.begin(async sql => {
      return await sql`
        INSERT INTO tenants ${sql(
          tenants.map(name => ({ name })), 
          'name'
        )}
        RETURNING id, name
      `;
    });

    console.log(`Added ${insertedTenants.length} tenants`);

    // Генерация пользователей
    const usersByTenant = new Map();
    for (const tenant of insertedTenants) {
      const userEmails = Array.from({ length: USERS_PER_TENANT }, (_, i) =>
        `user${i + 1}@${tenant.name.toLowerCase().replace(/ /g, '')}.com`
      );

      const users = await sql.begin(async sql => {
        return await sql`
          INSERT INTO users ${sql(userEmails.map(email => ({
            email,
            tenant_id: tenant.id
          })))}
          RETURNING id, tenant_id
        `;
      });

      usersByTenant.set(tenant.id, users);
    }
    console.log(`Added ${insertedTenants.length * USERS_PER_TENANT} users`);

    // Генерация заказов
    let totalOrders = 0;
    for (const [tenantId, users] of usersByTenant) {
      const userIds = users.map(u => u.id);
      const orders = Array.from({ length: ORDERS_PER_TENANT }, () => ({
        tenant_id: tenantId,
        user_id: userIds[Math.random() * userIds.length | 0],
        product_name: getRandomProduct(),
        amount: getRandomAmount(),
        created_at: getRandomDate()
      }));

      const orderChunks = chunk(orders, BATCH_SIZE);
      for (const batch of orderChunks) {
        await sql.begin(async sql => {
          await sql`
            INSERT INTO orders ${sql(batch)}
          `;
        });
        totalOrders += batch.length;
      }
    }
    console.log(`Added ${totalOrders} orders`);

  } catch (error) {
    console.error('Error:', error);
  } finally {
    await sql.end();
  }
}

generateData().then(() => console.log('Data generation completed'));
