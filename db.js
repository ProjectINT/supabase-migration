// db.js
import postgres from 'postgres';

// QuafBf3DINVnqng5
const connectionString = "postgresql://postgres.ndmjqubnagdlvnszrjgi:QuafBf3DINVnqng5@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"

const connectionString1 = "postgresql://postgres:QuafBf3DINVnqng5@db.ndmjqubnagdlvnszrjgi.supabase.co:5432/postgres"

const sql = postgres(connectionString)

export default sql

export const newPooller = () => {
  const sql = postgres(connectionString)
  return sql
}