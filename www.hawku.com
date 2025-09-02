<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>HAWKU</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 10px;
            background: #111;
            color: #fff;
            font-size: 18px;
        }
        h2 { text-align: center; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; min-width: 600px; }
        th, td { border: 1px solid #555; padding: 10px; text-align: center; font-size: 18px; }
        th { background: #222; }
        button {
            padding: 12px;
            margin: 4px 0;
            cursor: pointer;
            font-size: 18px;
            border-radius: 8px;
            background: #444;
            color: #fff;
            border: none;
        }
        button:hover { background: #666; }
        button:disabled {
            background: #2a2a2a;
            cursor: not-allowed;
            color: #888;
        }
        .terjual-container, .beli-container {
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }
        .terjual-angka, .beli-angka {
            font-weight: bold;
            font-size: 18px;
        }
        input, select {
            padding: 10px;
            font-size: 18px;
            width: 100%;
            box-sizing: border-box;
            border-radius: 6px;
            border: 1px solid #555;
            margin-bottom: 8px;
            background: #222;
            color: #fff;
        }
        .btn-row {
            margin-top: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .table-container {
            overflow-x: auto;
            margin-top: 10px;
            border: 1px solid #555;
            border-radius: 8px;
        }
        .foto-produk {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
        }
        /* Style untuk tabel total */
        .total-table {
            border: 1px solid #555;
            border-radius: 8px;
            margin-top: 20px;
        }
        .total-table td:first-child {
            text-align: left;
            font-weight: bold;
            background: #222;
        }
        .total-table td:last-child {
            text-align: center;
            background: #1a1a1a;
        }

        .potongan-cell {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .potongan-controls {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .potongan-controls button,
        .terjual-container button {
            padding: 4px 8px;
            font-size: 18px;
            line-height: 1;
        }
        /* Style untuk tombol hapus */
        .delete-cell {
            padding: 0;
            text-align: center;
            width: 30px;
        }
        .delete-button {
            width: 20px;
            height: 20px;
            background: #222;
            border: 1px solid #555;
            border-radius: 4px;
            color: #fff;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
            padding: 0;
        }
        .delete-button:hover {
            background: #333;
            color: #ff4d4d;
        }

        /* Modal Preview */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.8);
            padding-top: 20px;
        }

        .modal-content {
            background-color: #1a1a1a;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 700px;
            border-radius: 10px;
            position: relative;
            box-sizing: border-box;
            color: #fff;
            overflow: hidden;
        }

        .close-button {
            color: #fff;
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 30px;
            font-weight: bold;
            cursor: pointer;
        }

        .close-button:hover,
        .close-button:focus {
            color: #bbb;
        }

        #previewReportContainer {
            overflow: auto;
            max-height: 70vh;
            padding: 5px;
            margin-bottom: 15px;
            -webkit-overflow-scrolling: touch;
            touch-action: pan-x pan-y;
            width: 100%;
            box-sizing: border-box;
        }

        .preview-buttons {
            display: flex;
            flex-direction: row;
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        
        /* Gaya Laporan di dalam modal */
        #reportContainer {
            background: #111;
            padding: 20px;
            border-radius: 10px;
            color: #fff;
            width: fit-content;
            min-width: 600px;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            font-size: 16px;
            position: absolute;
            left: -9999px;
            top: -9999px;
            z-index: -1;
        }
        
        #reportContainer h2 {
            margin-bottom: 10px;
            font-size: 24px;
            text-align: center;
        }
        
        #reportContainer p {
            margin-bottom: 5px;
            text-align: left;
        }
        
        #reportContainer table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 16px;
        }
        
        #reportContainer th, #reportContainer td {
            border: 1px solid #555;
            padding: 8px;
            text-align: center;
            background: #222;
            color: #fff;
        }
        
        #reportContainer td {
            background: #1a1a1a;
        }
        
        /* Gaya khusus untuk tabel laporan gambar */
        #reportContainer #reportTable th, #reportContainer #reportTable td {
            text-align: center;
        }
        
        /* Gaya untuk kolom Subtotal dan Total Harga di laporan gambar */
        #reportContainer #reportTable td:nth-child(5) {
            text-align: center;
        }

        /* Gaya untuk tabel total di laporan gambar */
        #reportContainer .total-table td:first-child {
            text-align: left;
            font-weight: bold;
            background: #222;
        }
        
        #reportContainer .total-table td:last-child {
            text-align: center;
            background: #1a1a1a;
        }

        .hawker-controls {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 12px;
        }

        .hawker-controls button {
            padding: 10px;
            font-size: 16px;
            margin: 0;
        }

        #loginSection {
            text-align: center;
            margin-bottom: 20px;
            padding: 20px;
            border: 1px solid #555;
            border-radius: 8px;
        }

        #appSection, #calculatorSection {
            display: none;
        }
        
        #hapusAkunSection {
            display: none;
            margin-top: 15px;
            padding: 15px;
            border: 1px solid #555;
            border-radius: 8px;
            background: #222;
        }

        #loginMessage {
            color: #ff4d4d;
            margin-top: 10px;
        }
        
        /* Gaya baru untuk foto profil dan kontrolnya */
        #profileSection {
            text-align: center;
            margin-bottom: 20px;
        }
        #profileImageContainer {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 10px;
            cursor: pointer;
        }
        #profileImage {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #555;
            background: #222;
            transition: filter 0.3s;
        }

        /* Gaya baru untuk kontainer opsi di luar lingkaran profil */
        #profileOptionsContainer {
            text-align: center;
            margin-bottom: 10px;
            display: none; /* Sembunyikan secara default */
            justify-content: center;
            gap: 15px;
        }
        
        /* Memastikan overlay teks tampil saat aktif */
        #profileOptionsContainer.visible {
            display: flex; /* Tampilkan saat aktif */
        }

        /* Gaya teks Ganti, Hapus, dan Import */
        #profileOptionsContainer span {
            color: #fff;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            text-shadow: 1px 1px 2px #000;
        }

        #profileOptionsContainer span:hover {
            text-decoration: underline;
        }
        
        /* Terapkan efek blur pada gambar profil saat opsi terlihat */
        #profileImageContainer.visible #profileImage {
            filter: blur(3px);
        }
        
        #hawkerNameDisplay {
            margin: 0;
            font-size: 20px;
            font-weight: bold;
        }
        
        tr[draggable="true"] {
            cursor: move;
        }
        
        .foto-cell {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
        }
        .foto-cell button {
            padding: 5px 8px;
            font-size: 16px;
        }
        .small-button {
            padding: 4px 8px;
            font-size: 16px;
        }
        #tabelKalkulator th, #tabelKalkulator td {
            font-size: 20px;
        }
        .stok-habis {
            color: red;
            font-weight: bold;
        }
        .button-container {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
    </style>
</head>
<body>

<div id="profileOptionsContainer"></div>
<h2>HAWKU</h2>

<div id="loginSection">
    <h3>Login / Tambah Hawker</h3>
    <label>
        Pilih Akun:
        <select id="hawkerSelect" onchange="resetPasswordInput()"></select>
    </label>
    <label>
        Password:
        <input type="password" id="loginHawkerPassword" placeholder="Masukkan Password">
    </label>
    <button onclick="loginHawker()">Masuk</button>
    <div style="margin-top: 15px;">
        <hr>
        <h4>Daftar Akun Baru</h4>
        <input type="text" id="tambahHawkerName" placeholder="Nama Hawker Baru">
        <input type="password" id="tambahHawkerPassword" placeholder="Password Baru">
        <button onclick="tambahHawker()">Daftar</button>
        <button onclick="tampilkanHapusAkun()">Hapus Akun</button>
    </div>
    <div id="hapusAkunSection">
        <h4>Hapus Akun Terpilih</h4>
        <input type="password" id="hapusHawkerPassword" placeholder="Masukkan Password Akun">
        <button onclick="hapusHawker()">Konfirmasi Hapus</button>
        <button onclick="batalHapusAkun()">Batal</button>
    </div>
    <p id="loginMessage"></p>
</div>

<div id="appSection">
    <div id="profileSection">
        <input type="file" id="profilePicInput" accept="image/*" style="display:none;">
        <div id="profileImageContainer">
            <img id="profileImage" src="" alt="Foto Profil">
        </div>
        <h3 id="hawkerNameDisplay"></h3>
    </div>
    <hr>
    
    <button onclick="logout()">Keluar</button>

    <div class="hawker-controls">
        
    </div>
    <hr>

    <div class="btn-row">
        <input type="text" id="namaProduk" placeholder="Nama Produk">
        <input type="number" id="stokAwal" placeholder="Stok Awal">
        <input type="number" id="hargaProduk" placeholder="Harga Per PCS">
        <button onclick="tambahProduk()">Tambah Produk</button>
    </div>

    <div class="btn-row">
        <button id="simpanBtn" onclick="simpanData()">💾 Simpan Data</button>
        <button id="bukaKalkulatorBtn" onclick="tampilkanKalkulator()">🛒 Buka Penjualan</button>
    </div>
    <hr>

    <div class="table-container">
        <table id="tabelProduk">
            <thead>
                <tr>
                    <th class="delete-cell"></th>
                    <th>Gambar</th>
                    <th style="text-align: left;">Produk</th>
                    <th>Stok Awal</th>
                    <th>Sisa</th>
                    <th>Harga Per PCS (Rp)</th>
                    <th>Terjual</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="table-container total-table">
        <table>
            <tbody>
                <tr>
                    <td>Total Keseluruhan:</td>
                    <td id="totalKeseluruhan">Rp 0</td>
                </tr>
                <tr>
                    <td>
                        <div class="potongan-cell">
                            <span>Potongan (<span id="potonganPersenNilai">0</span>%):</span>
                            <div class="potongan-controls">
                                <button onclick="ubahPotongan(-1)">-</button>
                                <button onclick="ubahPotongan(1)">+</button>
                            </div>
                        </div>
                    </td>
                    <td id="potongan">Rp 0</td>
                </tr>
                <tr>
                    <td>Sisa Potongan:</td>
                    <td id="sisaPotongan">Rp 0</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="btn-row">
        <button onclick="kirimTeks()">📤 Kirim Laporan Teks ke WA</button>
        <button onclick="tampilkanPratinjau()">📸 Unduh Laporan Gambar</button>
    </div>
</div>

<div id="calculatorSection">
    <h3 style="text-align: center;">Penjualan</h3>
    <div class="table-container">
        <table id="tabelKalkulator">
            <thead>
                <tr>
                    <th style="text-align: left;">Produk</th>
                    <th>Harga</th>
                    <th>Jumlah</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
    <div class="table-container total-table">
        <table>
            <tbody>
                <tr>
                    <td>Total Pembelian:</td>
                    <td id="totalPembelian">Rp 0</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="total-table">
        <table>
            <tbody>
                <tr>
                    <td>Uang Diterima:</td>
                    <td>
                        <input type="text" id="uangDiterimaInput" placeholder="Masukkan nominal uang" oninput="formatUang(this); hitungKembalian();" style="text-align: center; width: 100%; font-size: 18px;">
                    </td>
                </tr>
                <tr>
                    <td>Kembalian:</td>
                    <td id="kembalianDisplay">Rp 0</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="btn-row">
        <button onclick="selesaikanTransaksi()">✅ Selesai</button>
        <button onclick="kembaliKeHalamanUtama()">🔙 Kembali</button>
    </div>
</div>

<div id="previewModal" class="modal">
    <div class="modal-content">
        <span class="close-button" onclick="tutupPratinjau()">&times;</span>
        <h3>Pratinjau Laporan</h3>
        
        <div id="previewReportContainer"></div>
        
        <div class="preview-buttons">
            <button onclick="unduhGambar()">Unduh Gambar</button>
            <button onclick="kirimGambar()">Kirim Gambar</button>
        </div>
    </div>
</div>

<div id="reportContainer"></div>

<script>
let hawkers = {};
let hawkerAktif = "";
let halamanAktif = "";

// Data untuk hawker yang sedang aktif
let produk = [];
let produkKalkulator = []; // Variabel baru untuk data di kalkulator
let potonganPersen = 0;

let draggedItem = null;

// =========================================================================
// SCRIPT UNTUK FOTO PROFIL
// =========================================================================

document.getElementById("profilePicInput").addEventListener("change", function(){
    if (this.files && this.files[0]) {
        bacaFotoProfil(this.files[0]);
    }
});

function bacaFotoProfil(file) {
    const reader = new FileReader();
    reader.onload = function(e) {
        if (hawkerAktif) {
            hawkers[hawkerAktif].profilePic = e.target.result;
            simpanDataHawkerKeLokal();
            renderProfilePicture();
        }
    };
    reader.readAsDataURL(file);
}

function showProfilePicOptions() {
    if (!hawkerAktif) {
        alert("Pilih atau tambahkan Hawker terlebih dahulu.");
        return;
    }

    const optionsContainer = document.getElementById('profileOptionsContainer');
    const hasProfilePic = hawkers[hawkerAktif].profilePic;
    optionsContainer.innerHTML = ''; 

    if (hasProfilePic) {
        optionsContainer.innerHTML = `
            <span id="gantiText">Ganti</span>
            <span id="hapusText">Hapus</span>
        `;
        document.getElementById('gantiText').onclick = function() {
            document.getElementById('profilePicInput').click();
            hideProfilePicOptions();
        };
        document.getElementById('hapusText').onclick = function() {
            if (confirm("Apakah Anda yakin ingin menghapus foto profil?")) {
                removeProfilePic();
            }
            hideProfilePicOptions();
        };
    } else {
        optionsContainer.innerHTML = `
            <span id="importText">Import</span>
        `;
        document.getElementById('importText').onclick = function() {
            document.getElementById('profilePicInput').click();
            hideProfilePicOptions();
        };
    }
    optionsContainer.classList.add('visible');
    document.getElementById('profileImageContainer').classList.add('visible');
}

function hideProfilePicOptions() {
    document.getElementById('profileOptionsContainer').classList.remove('visible');
    document.getElementById('profileImageContainer').classList.remove('visible');
}

document.addEventListener('click', function(event) {
    const profileContainer = document.getElementById('profileImageContainer');
    if (!profileContainer.contains(event.target) && !document.getElementById('profileOptionsContainer').contains(event.target)) {
        hideProfilePicOptions();
    }
});

document.getElementById("profileImageContainer").onclick = function(event) {
    event.stopPropagation();
    showProfilePicOptions();
};

function renderProfilePicture() {
    const profileImg = document.getElementById("profileImage");
    const hawkerData = hawkers[hawkerAktif];
    
    if (hawkerData && hawkerData.profilePic) {
        profileImg.src = hawkerData.profilePic;
    } else {
        profileImg.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3C/svg%3E";
    }
}

function removeProfilePic() {
    if (hawkerAktif) {
        hawkers[hawkerAktif].profilePic = null;
        simpanDataHawkerKeLokal();
        renderProfilePicture();
    }
}

// =========================================================================
// AKHIR SCRIPT FOTO PROFIL
// =========================================================================

function ubahPotongan(delta) {
    potonganPersen += delta;
    if (potonganPersen < 0) potonganPersen = 0;
    if (potonganPersen > 100) potonganPersen = 100;
    renderTabel();
}

// Fungsi untuk ubah jumlah terjual dari tabel utama atau kalkulator
function ubahQty(produkIndex, delta) {
    const isKalkulator = halamanAktif === 'kalkulator';
    
    // Gunakan data dari kalkulator jika halaman aktifnya kalkulator
    const p = isKalkulator ? produkKalkulator[produkIndex] : produk[produkIndex];
    const produkUtama = produk[produkIndex];
    
    if (p && produkUtama) {
        // Logika baru untuk memeriksa stok sisa
        const sisaSaatIni = produkUtama.stok - produkUtama.terjual;

        if (delta > 0 && sisaSaatIni <= 0) {
            alert("Stok produk ini sudah habis!");
            return;
        }

        if (delta < 0 && p.terjual + delta < 0) {
            return; // Cegah terjual menjadi negatif
        }

        if (isKalkulator) {
            p.terjual += delta;
            renderKalkulator();
        } else {
            // Perbarui jumlah terjual di objek produk utama
            p.terjual += delta;
            renderTabel();
        }
    }
}

function resetKembalian() {
    document.getElementById("uangDiterimaInput").value = '';
    document.getElementById("kembalianDisplay").innerText = "Rp 0";
}

function hitungKembalian() {
    const total = produkKalkulator.reduce((sum, p) => sum + (p.terjual * p.harga), 0);
    // Hapus "Rp " dan titik (thousand separator) sebelum parsing
    const uangDiterimaInput = document.getElementById("uangDiterimaInput").value.replace(/Rp /g, '').replace(/\./g, '');
    const uangDiterima = parseInt(uangDiterimaInput) || 0;
    const kembalian = uangDiterima - total;
    
    document.getElementById("kembalianDisplay").innerText = "Rp " + Math.round(kembalian).toLocaleString('id-ID');
}

function formatUang(input) {
    let value = input.value;
    
    // Hapus semua karakter non-digit dan "Rp "
    value = value.replace(/[^0-9]/g, '');
    
    let formattedValue = '';
    if (value) {
        // Konversi ke number, lalu format dengan titik sebagai thousand separator
        formattedValue = parseInt(value, 10).toLocaleString('id-ID');
    }
    
    // Tambahkan "Rp " di depan jika ada angka
    if (formattedValue) {
        input.value = "Rp " + formattedValue;
    } else {
        input.value = "";
    }
}

function renderKalkulator() {
    const tbody = document.querySelector("#tabelKalkulator tbody");
    tbody.innerHTML = "";
    let total = 0;

    const produkDiKalkulator = produkKalkulator.filter(p => (p.stok || 0) > 0);

    if (produkDiKalkulator.length === 0) {
        tbody.innerHTML = `<tr><td colspan="4" style="text-align: center; color: #aaa;">Tidak ada produk. Silakan tambahkan dari tabel utama.</td></tr>`;
    }

    produkDiKalkulator.forEach((p, index) => {
        const subtotal = p.terjual * p.harga;
        total += subtotal;

        const sisaDiTabelUtama = produk[index].stok - produk[index].terjual;
        const sisaSaatIniDiKalkulator = sisaDiTabelUtama - p.terjual;
        const stokHabisClass = sisaSaatIniDiKalkulator <= 0 ? 'stok-habis' : '';

        const row = document.createElement("tr");
        row.innerHTML = `
            <td style="text-align: left;">${p.nama}</td>
            <td>${p.harga.toLocaleString('id-ID')}</td>
            <td>
                <div class="beli-container">
                    <button onclick="ubahQty(${index}, -1)">-</button>
                    <div class="beli-angka ${stokHabisClass}">${p.terjual}</div>
                    <button onclick="ubahQty(${index}, 1)" ${sisaSaatIniDiKalkulator <= 0 ? 'disabled' : ''}>+</button>
                </div>
            </td>
            <td>Rp ${subtotal.toLocaleString('id-ID')}</td>
        `;
        tbody.appendChild(row);
    });

    document.getElementById("totalPembelian").innerText = "Rp " + total.toLocaleString('id-ID');
    hitungKembalian(); // Hitung kembalian setelah total diupdate
}

function tampilkanKalkulator() {
    // Salin data produk ke variabel kalkulator dan reset terjual
    produkKalkulator = JSON.parse(JSON.stringify(produk));
    produkKalkulator.forEach(p => p.terjual = 0);
    
    document.getElementById("appSection").style.display = "none";
    document.getElementById("calculatorSection").style.display = "block";
    halamanAktif = 'kalkulator';
    simpanStatusHalaman();
    
    resetKembalian();
    renderKalkulator();
    toggleMainTableEditing(false);
}

function kembaliKeHalamanUtama() {
    document.getElementById("calculatorSection").style.display = "none";
    document.getElementById("appSection").style.display = "block";
    halamanAktif = 'utama';
    simpanStatusHalaman();
    toggleMainTableEditing(true);
    renderTabel();
}

function selesaikanTransaksi() {
    // Sinkronkan data terjual dari produkKalkulator ke produk utama
    produkKalkulator.forEach((p, index) => {
        if (produk[index]) {
            produk[index].terjual += p.terjual;
        }
    });

    kembaliKeHalamanUtama();
}

function resetKalkulator() {
    produkKalkulator.forEach(p => p.terjual = 0);
    renderKalkulator();
}

function toggleMainTableEditing(enabled) {
    const table = document.getElementById("tabelProduk");
    const inputs = table.querySelectorAll('input, button');
    inputs.forEach(input => {
        if (input.id !== 'simpanBtn' && input.id !== 'bukaKalkulatorBtn') {
            input.disabled = !enabled;
        }
    });

    const formInputs = document.querySelectorAll('#namaProduk, #stokAwal, #hargaProduk');
    const formButton = document.querySelector('#appSection .btn-row button');
    formInputs.forEach(input => input.disabled = !enabled);
    formButton.disabled = !enabled;

    const mainButtons = document.querySelectorAll('#appSection .btn-row button');
    mainButtons.forEach(btn => btn.disabled = !enabled);
}

function hapusProduk(index) {
    produk.splice(index, 1);
    renderTabel();
}

function renderTabel() {
    const tbody = document.querySelector("#tabelProduk tbody");
    tbody.innerHTML = "";
    let total = 0;

    produk.forEach((p, index) => {
        const subtotal = p.terjual * p.harga;
        total += subtotal;

        const sisaBarang = (p.stok || 0) - p.terjual;
        const stokHabisClass = sisaBarang <= 0 ? 'stok-habis' : '';
        const tombolTambahDisabled = (sisaBarang <= 0) ? 'disabled' : '';

        const row = document.createElement("tr");
        row.setAttribute("draggable", "true");
        row.dataset.index = index;
        row.innerHTML = `
            <td class="delete-cell">
                <button class="delete-button" onclick="hapusProduk(${index})">✕</button>
            </td>
            <td>
                <div class="foto-cell">
                    ${p.foto 
                        ? `<img src="${p.foto}" class="foto-produk" onclick="toggleFotoControls(${index}, true)">`
                        : ''
                    }
                    <div class="button-container" style="${p.foto ? 'display: none;' : ''}">
                        <button onclick="document.getElementById('inputKamera${index}').click()">📷</button>
                        <button onclick="document.getElementById('inputGaleri${index}').click()">🖼️</button>
                        ${p.foto ? `<button onclick="hapusFoto(${index})">Hapus</button>` : ''}
                    </div>
                    <input type="file" id="inputKamera${index}" accept="image/*" capture="environment" style="display:none;" onchange="tambahFoto(${index}, event)">
                    <input type="file" id="inputGaleri${index}" accept="image/*" style="display:none;" onchange="tambahFoto(${index}, event)">
                </div>
            </td>
            <td style="text-align: left;">${p.nama}</td>
            <td>
                <input type="number" value="${p.stok}"
                       onchange="ubahStok(${index}, this.value)"
                       style="width:70px; text-align:center; font-size:18px; padding:6px;">
            </td>
            <td class="${stokHabisClass}">${sisaBarang}</td>
            <td>${p.harga.toLocaleString('id-ID')}</td>
            <td>
                <div class="terjual-container">
                    <button class="small-button" onclick="ubahQty(${index}, -1)">-</button>
                    <div class="terjual-angka">${p.terjual}</div>
                    <button class="small-button" onclick="ubahQty(${index}, 1)" ${tombolTambahDisabled}>+</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });

    const potongan = total * (potonganPersen / 100);
    const sisa = total - potongan;

    document.getElementById("potonganPersenNilai").innerText = potonganPersen;
    document.getElementById("totalKeseluruhan").innerText = "Rp " + total.toLocaleString('id-ID');
    document.getElementById("potongan").innerText = "Rp " + Math.round(potongan).toLocaleString('id-ID');
    document.getElementById("sisaPotongan").innerText = "Rp " + Math.round(sisa).toLocaleString('id-ID');

    const rows = tbody.querySelectorAll('tr');
    rows.forEach(row => {
        row.addEventListener('dragstart', handleDragStart);
        row.addEventListener('dragover', handleDragOver);
        row.addEventListener('drop', handleDrop);
        row.addEventListener('dragend', handleDragEnd);
    });
}

function tambahFoto(index, event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(e) {
        produk[index].foto = e.target.result;
        renderTabel();
    };
    reader.readAsDataURL(file);
}

function hapusFoto(index) {
    produk[index].foto = null;
    renderTabel();
}

function toggleFotoControls(index, showButtons) {
    const fotoCell = document.querySelector(`#tabelProduk tbody tr[data-index="${index}"] .foto-cell`);
    const imgElement = fotoCell.querySelector('img');
    const buttonContainer = fotoCell.querySelector('.button-container');

    if (showButtons) {
        if (imgElement) imgElement.style.display = 'none';
        if (buttonContainer) buttonContainer.style.display = 'flex';
    } else {
        if (imgElement) imgElement.style.display = 'block';
        if (buttonContainer) buttonContainer.style.display = 'none';
    }
}

// Drag and drop functions
function handleDragStart(e) {
    draggedItem = this;
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/html', this.innerHTML);
}

function handleDragOver(e) {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
}

function handleDrop(e) {
    e.preventDefault();
    if (this !== draggedItem) {
        const fromIndex = parseInt(draggedItem.dataset.index);
        const toIndex = parseInt(this.dataset.index);
        
        // Update the produk array
        const [movedItem] = produk.splice(fromIndex, 1);
        produk.splice(toIndex, 0, movedItem);

        renderTabel();
    }
}

function handleDragEnd(e) {
    draggedItem = null;
}

function tambahProduk() {
    if (!hawkerAktif) {
        alert("Mohon login terlebih dahulu.");
        return;
    }
    const nama = document.getElementById("namaProduk").value.trim();
    const stok = parseInt(document.getElementById("stokAwal").value);
    const harga = parseInt(document.getElementById("hargaProduk").value);
    
    if (nama && !isNaN(stok) && stok >= 0 && !isNaN(harga) && harga >= 0) {
        produk.push({ nama, stok, harga, terjual: 0, foto: null });
        document.getElementById("namaProduk").value = "";
        document.getElementById("stokAwal").value = "";
        document.getElementById("hargaProduk").value = "";
        renderTabel();
    } else {
        alert("Mohon isi semua data produk dengan benar (nama tidak boleh kosong, stok & harga harus angka positif).");
    }
}

function ubahStok(index, newValue) {
    const stokBaru = parseInt(newValue);
    if (!isNaN(stokBaru) && stokBaru >= 0) {
        produk[index].stok = stokBaru;
        if (produk[index].terjual > stokBaru) {
            produk[index].terjual = stokBaru;
        }
        renderTabel();
    } else {
        alert("Stok harus berupa angka positif.");
        renderTabel();
    }
}

function simpanData() {
    if (!hawkerAktif) {
        alert("Pilih atau tambahkan Hawker terlebih dahulu.");
        return;
    }
    hawkers[hawkerAktif].data = {
        produk: produk,
        potonganPersen: potonganPersen
    };
    localStorage.setItem("dataPenjualanSariRoti_Hawkers", JSON.stringify(hawkers));
    alert("Data berhasil disimpan! 💾");
}

function kirimTeks() {
    if (!hawkerAktif) {
        alert("Pilih atau tambahkan Hawker terlebih dahulu.");
        return;
    }
    const produkYangDikirim = produk.filter(p => p.stok > 0);
    if (produkYangDikirim.length === 0) {
        alert("Tidak ada produk untuk dilaporkan.");
        return;
    }

    const tanggal = new Date().toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'});

    let pesan = `*Laporan Penjualan HAWKU*\n\n`;
    pesan += `*Nama Hawker:* ${hawkerAktif}\n`;
    pesan += `*Tanggal:* ${tanggal}\n\n`;
    
    produkYangDikirim.forEach((p, i) => {
        const subtotal = p.terjual * p.harga;
        const sisaBarang = (p.stok || 0) - p.terjual;
        pesan += `*${i + 1}. ${p.nama}*\n`;
        pesan += `Stok Awal: ${p.stok}\n`;
        pesan += `Terjual: ${p.terjual}\n`;
        pesan += `Sisa: ${sisaBarang}\n`;
        pesan += `Subtotal: Rp ${subtotal.toLocaleString('id-ID')}\n\n`;
    });
    
    let totalKeseluruhan = produkYangDikirim.reduce((sum, p) => sum + (p.terjual * p.harga), 0);
    const potongan = totalKeseluruhan * (potonganPersen / 100);
    const sisaSetelahPotongan = totalKeseluruhan - potongan;
    
    pesan += `--- Ringkasan ---\n`;
    pesan += `*Total Keseluruhan:* Rp ${totalKeseluruhan.toLocaleString('id-ID')}\n`;
    pesan += `*Potongan (${potonganPersen}%):* Rp ${Math.round(potongan).toLocaleString('id-ID')}\n`;
    pesan += `*Sisa Potongan:* Rp ${Math.round(sisaSetelahPotongan).toLocaleString('id-ID')}\n`;

    const encodedPesan = encodeURIComponent(pesan);
    window.open(`https://api.whatsapp.com/send?text=${encodedPesan}`, "_blank");
}

function tampilkanPratinjau() {
    if (!hawkerAktif) {
        alert("Pilih atau tambahkan Hawker terlebih dahulu.");
        return;
    }
    const produkYangDikirim = produk.filter(p => p.stok > 0);
    if (produkYangDikirim.length === 0) {
        alert("Tidak ada produk untuk dilaporkan.");
        return;
    }
    
    const previewContainer = document.getElementById('previewReportContainer');
    const tanggal = new Date().toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'});

    let reportHtml = `
        <div id="captureArea" style="padding: 20px; background: #111; color: #fff;">
            <h2 style="text-align:center; color:#fff; margin-bottom:10px;">Laporan Penjualan HAWKU</h2>
            <p style="color:#fff; margin-bottom:5px;"><b>Nama Hawker:</b> ${hawkerAktif}</p>
            <p style="color:#fff; margin-bottom:15px;"><b>Tanggal:</b> ${tanggal}</p>
            <div style="margin-top:0; border:1px solid #555; border-radius:8px; overflow:auto;">
                <table id="reportTable" style="width:100%; min-width: 600px; border-collapse:collapse; font-size:16px;">
                    <thead>
                        <tr>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555; text-align:center;">Gambar</th>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555; text-align:left;">Produk</th>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555;">Stok Awal</th>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555;">Terjual</th>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555;">Sisa</th>
                            <th style="background:#222; color:#fff; padding:8px; border:1px solid #555;">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
    `;

    let totalKeseluruhanUntukGambar = 0;

    produkYangDikirim.forEach((p) => {
        const subtotal = p.terjual * p.harga;
        const sisaBarang = (p.stok || 0) - p.terjual;
        totalKeseluruhanUntukGambar += subtotal;

        reportHtml += `
            <tr>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">${p.foto ? `<img src="${p.foto}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;">` : ""}</td>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:left;">${p.nama}</td>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">${p.stok}</td>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">${p.terjual}</td>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">${sisaBarang}</td>
                <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">Rp ${subtotal.toLocaleString('id-ID')}</td>
            </tr>
        `;
    });

    reportHtml += `
                    </tbody>
                </table>
            </div>
            
            <div style="margin-top:20px; border:1px solid #555; border-radius:8px; overflow:auto;">
                <table style="width:100%; min-width: 300px; border-collapse:collapse; font-size:16px;">
                    <tbody>
                        <tr>
                            <td style="background:#222; color:#fff; padding:8px; border:1px solid #555; text-align:left; font-weight:bold;">Total Keseluruhan:</td>
                            <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">Rp ${totalKeseluruhanUntukGambar.toLocaleString('id-ID')}</td>
                        </tr>
        `;

    const potonganUntukGambar = totalKeseluruhanUntukGambar * (potonganPersen / 100);
    const sisaSetelahPotonganUntukGambar = totalKeseluruhanUntukGambar - potonganUntukGambar;

    reportHtml += `
                        <tr>
                            <td style="background:#222; color:#fff; padding:8px; border:1px solid #555; text-align:left; font-weight:bold;">Potongan (${potonganPersen}%):</td>
                            <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">Rp ${Math.round(potonganUntukGambar).toLocaleString('id-ID')}</td>
                        </tr>
                        <tr>
                            <td style="background:#222; color:#fff; padding:8px; border:1px solid #555; text-align:left; font-weight:bold;">Sisa Potongan:</td>
                            <td style="background:#1a1a1a; color:#fff; padding:8px; border:1px solid #555; text-align:center;">Rp ${Math.round(sisaSetelahPotonganUntukGambar).toLocaleString('id-ID')}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    `;

    previewContainer.innerHTML = reportHtml;
    document.getElementById('previewModal').style.display = 'block';
}

function unduhGambar() {
    const reportContainer = document.getElementById('reportContainer');
    const previewContainer = document.getElementById('previewReportContainer');

    reportContainer.innerHTML = previewContainer.innerHTML;

    html2canvas(reportContainer, {
        backgroundColor: '#111',
        scale: 2,
        useCORS: true,
        scrollX: 0,
        scrollY: 0,
        width: reportContainer.offsetWidth,
        height: reportContainer.offsetHeight
    }).then(canvas => {
        const link = document.createElement('a');
        link.href = canvas.toDataURL('image/png');
        const tanggal = new Date().toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'});
        link.download = `Laporan_Penjualan_HAWKU_${tanggal.replace(/ /g, '_')}_${hawkerAktif}.png`;
        link.click();
        
        tutupPratinjau();
        alert("Gambar laporan berhasil diunduh. ✅");
    }).catch(error => {
        console.error("Gagal membuat gambar laporan:", error);
        tutupPratinjau();
        alert("Gagal membuat gambar laporan. Silakan coba lagi. ❌");
    });
}

function kirimGambar() {
    const reportContainer = document.getElementById('reportContainer');
    const previewContainer = document.getElementById('previewReportContainer');

    reportContainer.innerHTML = previewContainer.innerHTML;

    html2canvas(reportContainer, {
        backgroundColor: '#111',
        scale: 2,
        useCORS: true,
        scrollX: 0,
        scrollY: 0,
        width: reportContainer.offsetWidth,
        height: reportContainer.offsetHeight
    }).then(async canvas => {
        try {
            const dataUrl = canvas.toDataURL('image/png');
            if (navigator.share) {
                const blob = await (await fetch(dataUrl)).blob();
                const file = new File([blob], 'laporan_hawku.png', { type: 'image/png' });
                
                await navigator.share({
                    files: [file],
                    title: 'Laporan Penjualan HAWKU',
                    text: 'Laporan penjualan HAWKU tanggal ' + new Date().toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'}) + ' untuk ' + hawkerAktif
                });
            } else {
                // Fallback for browsers that don't support Web Share API
                alert("Perangkat Anda tidak mendukung fitur 'Kirim Gambar'. Silakan gunakan tombol 'Unduh' lalu kirimkan secara manual.");
                const link = document.createElement('a');
                link.href = dataUrl;
                link.download = `Laporan_Penjualan_HAWKU_${new Date().toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'}).replace(/ /g, '_')}_${hawkerAktif}.png`;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        } catch (error) {
            console.error('Error sharing the image:', error);
        }
        tutupPratinjau();
    }).catch(error => {
        console.error("Gagal membuat gambar laporan:", error);
        alert("Gagal membuat gambar laporan. Silakan coba lagi. ❌");
        tutupPratinjau();
    });
}

function tutupPratinjau() {
    document.getElementById('previewModal').style.display = 'none';
    document.getElementById('previewReportContainer').innerHTML = '';
}

// =========================================================================
// SCRIPT BARU UNTUK MANAJEMEN HAWKER DENGAN LOGIN
// =========================================================================

function renderHawkerList() {
    const hawkerSelect = document.getElementById('hawkerSelect');
    hawkerSelect.innerHTML = "";
    
    // Tambahkan opsi kosong sebagai default
    const defaultOption = document.createElement('option');
    defaultOption.text = "Pilih Akun...";
    defaultOption.value = "";
    defaultOption.disabled = true;
    defaultOption.selected = true;
    hawkerSelect.add(defaultOption);

    // Tambahkan hawker yang sudah ada
    for (const name in hawkers) {
        const option = document.createElement('option');
        option.text = name;
        option.value = name;
        hawkerSelect.add(option);
    }
}

function resetPasswordInput() {
    document.getElementById('loginHawkerPassword').value = '';
    document.getElementById('loginMessage').innerText = '';
}

function muatDataHawker() {
    const hawkerNameDisplay = document.getElementById("hawkerNameDisplay");
    
    const dataHawker = hawkers[hawkerAktif];
    if (dataHawker) {
        hawkerNameDisplay.innerText = hawkerAktif;
        if (dataHawker.data) {
            produk = dataHawker.data.produk || [];
            potonganPersen = dataHawker.data.potonganPersen || 0;
        } else {
            produk = [];
            potonganPersen = 0;
        }
    } else {
        hawkerNameDisplay.innerText = "";
        produk = [];
        potonganPersen = 0;
    }

    renderProfilePicture();
    renderTabel();
}

function loginHawker() {
    const name = document.getElementById('hawkerSelect').value;
    const password = document.getElementById('loginHawkerPassword').value.trim();
    const messageElement = document.getElementById('loginMessage');
    
    if (!name) {
        messageElement.innerText = "Pilih akun terlebih dahulu.";
        messageElement.style.color = '#ff4d4d';
        return;
    }

    if (hawkers[name] && hawkers[name].password === password) {
        hawkerAktif = name;
        document.getElementById('loginSection').style.display = 'none';
        document.getElementById('appSection').style.display = 'block';
        halamanAktif = 'utama'; // Set halaman aktif setelah login
        simpanStatusHalaman();
        muatDataHawker();
        messageElement.innerText = `Berhasil masuk sebagai ${hawkerAktif}!`;
        messageElement.style.color = 'green';
        document.getElementById('loginHawkerPassword').value = '';
    } else {
        messageElement.innerText = "Password salah. Silakan coba lagi.";
        messageElement.style.color = '#ff4d4d';
    }
}

function tampilkanHapusAkun() {
    document.getElementById('hapusAkunSection').style.display = 'block';
}

function batalHapusAkun() {
    document.getElementById('hapusAkunSection').style.display = 'none';
    document.getElementById('hapusHawkerPassword').value = '';
    document.getElementById('loginMessage').innerText = '';
}

function tambahHawker() {
    const name = document.getElementById('tambahHawkerName').value.trim();
    const password = document.getElementById('tambahHawkerPassword').value.trim();
    const messageElement = document.getElementById('loginMessage');

    if (!name || !password) {
        messageElement.innerText = "Nama dan password harus diisi.";
        messageElement.style.color = '#ff4d4d';
        return;
    }

    if (hawkers[name]) {
        messageElement.innerText = "Nama Hawker sudah terdaftar.";
        messageElement.style.color = '#ff4d4d';
        return;
    }

    if (confirm(`Apakah Anda yakin ingin mendaftarkan Hawker baru dengan nama "${name}"?`)) {
        hawkers[name] = {
            password: password,
            data: {
                produk: [],
                potonganPersen: 0
            },
            profilePic: null 
        };
        simpanDataHawkerKeLokal();
        renderHawkerList(); // Perbarui daftar hawker di dropdown
        document.getElementById('tambahHawkerName').value = '';
        document.getElementById('tambahHawkerPassword').value = '';
        messageElement.innerText = `Hawker "${name}" berhasil didaftarkan! Silakan masuk.`;
        messageElement.style.color = 'green';
    }
}

function hapusHawker() {
    const hawkerTerpilih = document.getElementById('hawkerSelect').value;
    const password = document.getElementById('hapusHawkerPassword').value.trim();
    const messageElement = document.getElementById('loginMessage');
    
    if (!hawkerTerpilih) {
        messageElement.innerText = "Pilih akun yang ingin dihapus terlebih dahulu.";
        messageElement.style.color = '#ff4d4d';
        return;
    }
    
    if (hawkers[hawkerTerpilih] && hawkers[hawkerTerpilih].password === password) {
        if (confirm(`Apakah Anda yakin ingin menghapus akun dan semua data "${hawkerTerpilih}"? Ini tidak bisa dibatalkan!`)) {
            delete hawkers[hawkerTerpilih];
            simpanDataHawkerKeLokal();
            renderHawkerList();
            batalHapusAkun();
            messageElement.innerText = `Akun "${hawkerTerpilih}" berhasil dihapus. ✅`;
            messageElement.style.color = 'green';
        }
    } else {
        messageElement.innerText = "Password salah. Tidak dapat menghapus akun.";
        messageElement.style.color = '#ff4d4d';
    }
}

function logout() {
    simpanData(); // Simpan data sebelum logout
    hawkerAktif = "";
    halamanAktif = "";
    produk = [];
    potonganPersen = 0;
    renderTabel();
    document.getElementById('loginSection').style.display = 'block';
    document.getElementById('appSection').style.display = 'none';
    document.getElementById('calculatorSection').style.display = 'none';
    document.getElementById('hawkerSelect').value = '';
    document.getElementById('loginHawkerPassword').value = '';
    document.getElementById('loginMessage').innerText = '';
    batalHapusAkun();
    renderHawkerList();
    simpanStatusHalaman();
}

function simpanDataHawkerKeLokal() {
    localStorage.setItem("dataPenjualanSariRoti_Hawkers", JSON.stringify(hawkers));
}

function simpanStatusHalaman() {
    localStorage.setItem("statusHAWKU", JSON.stringify({
        hawkerAktif: hawkerAktif,
        halamanAktif: halamanAktif
    }));
}

function muatDataAwal() {
    const dataLokal = localStorage.getItem("dataPenjualanSariRoti_Hawkers");
    if (dataLokal) {
        hawkers = JSON.parse(dataLokal);
    }

    const statusLokal = localStorage.getItem("statusHAWKU");
    if (statusLokal) {
        const status = JSON.parse(statusLokal);
        hawkerAktif = status.hawkerAktif;
        halamanAktif = status.halamanAktif;

        if (hawkerAktif) {
            document.getElementById('loginSection').style.display = 'none';
            if (halamanAktif === 'kalkulator') {
                document.getElementById('appSection').style.display = 'none';
                document.getElementById('calculatorSection').style.display = 'block';
                muatDataHawker();
                // Untuk kalkulator, perlu memuat ulang data dari tabel utama agar sinkron
                produkKalkulator = JSON.parse(JSON.stringify(produk));
                renderKalkulator();
                toggleMainTableEditing(false);
            } else {
                document.getElementById('appSection').style.display = 'block';
                document.getElementById('calculatorSection').style.display = 'none';
                muatDataHawker();
                toggleMainTableEditing(true);
            }
        } else {
            document.getElementById('loginSection').style.display = 'block';
            document.getElementById('appSection').style.display = 'none';
            document.getElementById('calculatorSection').style.display = 'none';
        }
    } else {
        document.getElementById('loginSection').style.display = 'block';
        document.getElementById('appSection').style.display = 'none';
        document.getElementById('calculatorSection').style.display = 'none';
    }

    renderHawkerList();
}

window.onload = muatDataAwal;
</script>

</body>
</html>
