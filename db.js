// db.js
import postgres from 'postgres'

const connectionString = "postgresql://postgres:[YOUR-PASSWORD]@db.ndmjqubnagdlvnszrjgi.supabase.co:5432/postgres"

const sql = postgres(connectionString)

export default sql