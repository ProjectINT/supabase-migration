// db.js
import postgres from 'postgres';

// QuafBf3DINVnqng5
const connectionString = "postgresql://postgres.ndmjqubnagdlvnszrjgi:QuafBf3DINVnqng5@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"

const sql = postgres(connectionString)

export default sql