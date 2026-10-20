import { createClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

// Null until project environment variables are configured. Never expose service-role keys here.
export const supabase = url && anonKey ? createClient(url, anonKey) : null;
