# GolfShop.id — starter website
## Isi
- `index.html`: katalog responsif berbahasa Indonesia, pencarian/filter, keranjang pilihan, pengelolaan produk demo.
- `supabase_schema.sql`: skema awal katalog Supabase.
- `api/create-transaction.js`: endpoint Vercel untuk membuat transaksi Midtrans Snap.
- `netlify/functions/create-transaction.js`: endpoint Netlify setara.

## Jalankan lokal
Buka folder di VS Code lalu jalankan Live Server pada `index.html`. Untuk menguji endpoint Vercel: `npm install -g vercel`, `vercel dev`.

## Deploy
Vercel: push folder ke GitHub, Import Project di Vercel, framework Other, build command kosong, output `.`. Tambahkan Environment Variable `MIDTRANS_SERVER_KEY` hanya pada server.
Netlify: drag-and-drop folder untuk katalog statis; untuk fungsi pembayaran, deploy repo GitHub dan pastikan Netlify Functions aktif.

## Catatan penting sebelum produksi
Versi awal ini adalah katalog/etalase. Tombol marketplace membuka toko asal; checkout dan pembayaran dilakukan di platform asal. Form Kelola menyimpan ke localStorage browser, bukan database bersama, dan TIDAK memiliki autentikasi admin. Jangan gunakan mode demo untuk menerima pembayaran atau menyimpan data pelanggan.
Untuk penjualan langsung: sambungkan katalog ke Supabase, buat login admin (Supabase Auth), kebijakan RLS khusus admin, tabel orders/order_items, validasi harga dan stok di server, panggil endpoint Midtrans, lalu verifikasi notifikasi/webhook Midtrans di server sebelum menandai pesanan lunas. Jangan percaya nominal dari browser. Jangan pernah memasukkan Server Key Midtrans ke HTML.
Untuk dropship/affiliate: jangan mengandalkan scraping halaman Shopee/Tokopedia. Masukkan URL produk secara manual atau gunakan API/feed/tautan affiliate resmi yang disediakan dan diizinkan platform. Pastikan hak penggunaan foto, deskripsi, merek, dan syarat program affiliate/marketplace dipatuhi.

## Modul Artikel Golf
Bagian Artikel Golf menambahkan kategori Lapangan Golf, Teknik Bermain, Aplikasi & Teknologi, Merek & Produk, serta Pertandingan. Pengunjung dapat memfilter kategori dan membaca artikel melalui tampilan detail. Form admin demo memungkinkan penulisan, penerbitan, dan penghapusan artikel; data tersimpan di localStorage browser.
Contoh artikel awal adalah materi panduan umum, bukan berita pertandingan aktual. Untuk berita/jadwal/hasil terkini, redaksi harus memverifikasi informasi dari sumber resmi dan mencantumkan tanggal serta tautan sumber. Untuk produksi, pindahkan artikel ke CMS/database (misalnya tabel articles di Supabase), tambahkan autentikasi, status draft/published, slug, SEO metadata, dan role editor.
