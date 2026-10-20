# Fast NFT Courier — Website Starter

A responsive Next.js starter with homepage, tracking UI, Supabase tracking query, sign-in form, admin dashboard preview, and PostgreSQL schema.

## Included
- Responsive navy/white/orange courier website
- Homepage, tracking page, customer sign-in page, and admin dashboard preview
- Supabase client setup using environment variables
- Database schema for profiles, shipments, tracking events, and audit logs
- No fabricated shipment data

## Important implementation status
**Included in the source:** UI, responsive styling, tracking query code, sign-in form integration, schema starter.
**Still needs configuration or implementation:** live Supabase project and credentials, public tracking API with rate limiting, signup/password reset/MFA, protected admin writes, customer portal, audit-log writes, notifications, AI provider, carrier APIs, payment, GPS/maps, production monitoring and backups.
The admin page is only a preview and must not be used to administer real shipments. The browser-side tracking query is a starter integration; do not enable anonymous database reads just to make it work.
The support email uses the reserved `.example` domain. Replace it with your actual support address before launch.

## Requirements
Node.js 20+, Supabase project (for backend), GitHub and Vercel accounts (for deployment).

## Run locally
1. Extract the ZIP and open the project folder in a terminal.
2. Run `npm install`.
3. Copy `.env.example` to `.env.local`.
4. Run `npm run dev`, then open `http://localhost:3000`.
5. Set the Supabase URL and anon key in `.env.local` when you have created a project.

## Set up Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Add `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` to `.env.local`.
4. Configure Auth and test customer/staff/admin roles and row-level security.
5. Before launch, build a rate-limited server-side tracking route that returns only approved tracking fields. Do not expose recipient personal information.
6. Implement server-verified admin/staff writes and audit logs. Never ship the service-role key to the browser.

## Deploy and get a preview URL
1. Push the extracted project to a private GitHub repository.
2. Sign in at https://vercel.com and import the repository.
3. Add the two `NEXT_PUBLIC_SUPABASE_...` environment variables in Vercel project settings.
4. Deploy. Vercel will create a URL you can open and share.
5. Add the deployed domain to Supabase Auth's allowed redirect URLs.
6. Test the site on mobile and desktop, and test database policies using separate test accounts before entering real customer data.

## Production checklist
- [ ] Replace placeholder contact details.
- [ ] Add rate limiting and abuse monitoring to public tracking.
- [ ] Enforce server-side authorization and review RLS.
- [ ] Add account recovery, MFA, session handling, and customer portal.
- [ ] Add audited shipment creation and status update routes.
- [ ] Configure email/SMS provider and opt-in/opt-out.
- [ ] Connect real carrier/dispatch systems for genuine shipment updates.
- [ ] Add AI features only through server-side routes; keep secrets private.
- [ ] Configure monitoring, backups, privacy notice, terms, and incident response.
- [ ] Verify the business is operationally and legally ready for advertised services.
