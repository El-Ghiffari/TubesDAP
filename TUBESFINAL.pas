program Tubes;

uses crt,sysutils;

const max = 1000;

type
        DataPelanggan = record
        KodePelanggan, Nama, Nomor, Paket, Rekening : string;
        Kupon : integer;
        Biaya : real;
        TanggalBayar : TDateTime;
end;

type    TPelanggan = record
        TP : array [1..max] of DataPelanggan;
        Tanggal : TDateTime;
end;
var
        TabPelanggan: TPelanggan;
        Pilih : char;
        Ulang : boolean;
        N,nomor : integer;
        YY,MM,DD : word;
        ArsipPelanggan : File of TPelanggan;
        ArsipBanyakData : File of integer;
// ===============================================================================
// bantuan
        function DiskonK (T:TPelanggan;k,i:integer):real;
        //menghitung diskon kupon
        begin
                DiskonK := T.TP[i].Biaya * k / 100;
        end;

        function DiskonT (T:TPelanggan;i:integer):real;
        //menghitung diskon tanggal
        var
                YY,MM,DD:word;
        begin
                DecodeDate(Date,YY,MM,DD);
                if (DD <= 10) then
                        DiskonT := T.TP[i].Biaya * 5 / 100
                else
                        DiskonT := 0;
        end;

        function SenggangWaktu():TDateTime;
        //toleransi masa aktif
        begin
                SenggangWaktu := date + 10;
        end;

        procedure Garis();
        begin
                writeln('==================================================');
        end;

        procedure Kembali();
        begin
                garis();
                writeln('Tekan enter untuk kembali ke menu utama');
                readln();
        end;

        procedure ErrorInput(var T : string);
        begin
                while (T = '') do
                begin
                        write('data tidak boleh kosong: ');
                        readln(T);
                end;
        end;

        Procedure ErrorHandling(var data : char);
        begin
                while (data <> 't') and (data <> 'T') and (data <> 'y') and (data <> 'Y') do
                begin
                        write('Masukkan "Y" untuk ya dan "T" untuk tidak: ');
                        readln(data);
                end;
        end;
//========================================================================================
//input
        procedure InputNama(i:integer; var T:TPelanggan;s : string);
        //I.s -
        //F.s input nama ke dalam tabel
        begin
                write('Nama lengkap: ');
                readln(T.TP[i].Nama);
                ErrorInput(T.TP[i].Nama);
                T.TP[N].KodePelanggan := Format('%d',[DD]) + lowerCase(T.TP[N].nama[1..2]) + s;
        end;

        procedure InputNomor(i:integer; var T:TPelanggan);
        //I.s -
        //F.s input nomor telepon ke dalam tabel
        begin
                write('Nomor telepon: ');
                readln(T.TP[i].Nomor);
                ErrorInput(T.TP[i].Nomor);
        end;

        Procedure InputRekening(i:integer; var T:TPelanggan);
        //I.s -
        //F.s input nomor rekening ke dalam tabel
        begin
                write('Nomor rekening: ');
                readln(T.TP[i].Rekening);
                ErrorInput(T.TP[i].Rekening);
        end;

        procedure InputPaket(i:integer; var T:TPelanggan);
        //I.s -
        //F.s input paket ke dalam tabel
        var
                pilihan : char;
        begin
                clrscr;
                writeln('PILIH PAKET');
                garis();
                writeln('1. Paket hemat   = Rp.50,000/bulan');
                writeln('2. Paket standar = Rp.100,000/bulan');
                writeln('3. Paket plus    = Rp.250,000/bulan');
                writeln('4. Paket full    = Rp.500,000/bulan');
                garis();
                write('Pilih paket yang anda inginkan: ');
                readln(pilihan);
                case pilihan of
                        '1':begin
                                T.TP[i].Biaya := 50000;
                                T.TP[i].Paket := 'Hemat';
                            end;
                        '2':begin
                                T.TP[i].Biaya := 100000;
                                T.TP[i].Paket := 'Standar';
                            end;
                        '3':begin
                                T.TP[i].Biaya := 250000;
                                T.TP[i].Paket := 'Plus';
                            end;
                        '4':begin
                                T.TP[i].Biaya := 500000;
                                T.TP[i].Paket := 'Full';
                            end;
                        else InputPaket(i,T)
                end;
        end;
//==============================================================================
// data pelanggan
        procedure DataP(i:integer);
        //I.s tabel terdefinisi
        //F.s menampilkan isi tabel[i]
        begin
                garis;
                writeln('||            Kode pelanggan: ',TabPelanggan.TP[i].KodePelanggan,'              ||');
                garis;
                writeln('Nama lengkap: ',TabPelanggan.TP[i].Nama);
                writeln('Nomor telepon: ',TabPelanggan.TP[i].Nomor);
                writeln('Nomor rekening: ',TabPelanggan.TP[i].Rekening);
                writeln('Paket: ',TabPelanggan.TP[i].Paket);
                writeln('Masa aktif: ',DateTimeToStr(TabPelanggan.TP[i].TanggalBayar));
                writeln('Jumlah kupon: ',TabPelanggan.TP[i].kupon);
        end;

        Procedure CekData(i:integer);
        begin
                clrscr;
                writeln('CEK DATA');
                garis();
                DataP(i);
        end;

        procedure GantiData(i:integer; var pilih:char;s:string);
        var
                pilihan : char;
        begin
                writeln('GANTI DATA');
                garis();
                writeln('1. Nama');
                writeln('2. Nomor Telepon');
                writeln('3. Nomor Rekening');
                writeln('4. Paket');
                garis();
                write('Pilih menu yang anda inginkan: ');
                readln(pilihan);
                case pilihan of
                        '1':InputNama(i,TabPelanggan,s);
                        '2':InputNomor(i,TabPelanggan);
                        '3':InputRekening(i,TabPelanggan);
                        '4':InputPaket(i,TabPelanggan);
                end;
                CekData(i);
                write('Apakah data anda sudah benar? (Y/T): ');
                readln(pilih);
                ErrorHandling(pilih);
        end;

        procedure InputData(var T:TPelanggan;var N,m : integer);
        var
                s : string;
                pilih: char;
        begin
                N := N + 1;
                m := m + 1;
                str(m,s);
                T.TP[N].TanggalBayar := SenggangWaktu;
                clrscr;
                writeln('MULAI BERLANGGANAN');
                garis();
                InputNama(N,T,s);
                InputNomor(N,T);
                InputRekening(N,T);
                InputPaket(N,T);
                repeat
                        CekData(N);
                        Garis;
                        writeln('MOHON DIINGAT NOMOR PELANGGAN ANDA');
                        Garis;
                        write('Apakah data anda sudah benar? (Y/T): ');
                        readln(pilih);
                        ErrorHandling(pilih);
                        while (pilih = 'T') or (pilih = 't') do
                        begin
                                garis();
                                GantiData(N,pilih,s);
                        end;
                until(pilih = 'y') or (pilih = 'Y');
                clrscr;
                Garis;
                writeln('PENDAFTARAN SUKSES');
                Garis;
                writeln('Terima kasih sudah mendaftar pada aplikasi ini :)');
                kembali;
        end;

//======================================================================================
// pencarian

        procedure CariData(T:TPelanggan; var i : integer; var found : boolean);
        var
                top,bot : integer;
                no : string;
        begin
                write('Masukkan nomor pelanggan anda: ');
                readln(no);
                found := false;
                if (no = '') then
                begin
                        writeln('Data pelanggan tidak ditemukan');
                        kembali();
                end
                else
                begin
                        i := 1;
                        while (i <= N) and (not found) do
                                if (T.TP[i].KodePelanggan = no) then
                                        found := True
                                else
                                        i := i + 1;
                        if (Found = False) then
                        begin
                                writeln('Data pelanggan tidak ditemukan');
                                kembali();
                        end;
                end;
        end;

        procedure CekStatus(T:Tpelanggan);
        var
                i:integer;
                pilihan:char;
                F:boolean;
        begin
                clrscr;
                writeln('CEK STATUS');
                garis();
                begin
                        CariData(T,i,F);
                        if (F) then
                        begin
                                DataP(i);
                                kembali();
                        end;
                end;
        end;

// update

        procedure GantiPaket(var T:TPelanggan);
        var
                i:integer;
                F:boolean;
                pilih:char;
        begin
                clrscr;
                writeln('GANTI PAKET');
                garis();
                CariData(T,i,F);
                if (F) then
                begin
                        garis;
                        writeln('Paket anda sekarang: ',T.TP[i].paket);
                        garis();
                        write('Tekan enter untuk melanjutkan');
                        readln();
                        InputPaket(i,T);
                        garis;
                        writeln('Jika anda mengganti paket, maka pembayaran sebelumnya akan hangus.');
                        write('Apakah anda yakin untuk mengganti paket? (Y/T): ');
                        readln(pilih);
                        ErrorHandling(pilih);
                        T.TP[i].TanggalBayar := SenggangWaktu;
                        clrscr;
                        garis;
                        writeln('PENGGANTIAN PAKET SUKSES');
                        Kembali;
                end;
        end;
// delete
        Procedure DeleteT(idx:integer;var n:integer;var T:TPelanggan);
        var
                i:integer;
        begin
                for i := idx to N do
                        T.TP[i] := T.TP[i+1];
                N := N - 1;
        end;

        procedure Berhenti(var T:TPelanggan;var N:integer);
        var
                i:integer;
                f:boolean;
                pilih:char;
        begin
                clrscr;
                writeln('BERHENTI BERLANGGANAN');
                garis();
                CariData(T,i,F);
                if (F) then
                begin
                        DataP(i);
                        write('Apakah anda yakin untuk berhenti berlangganan? (Y/T): ');
                        readln(pilih);
                        ErrorHandling(pilih);
                        if ((pilih = 'Y') or (pilih = 'y')) then
                        begin
                                DeleteT(i,n,t);
                                clrscr;
                                garis;
                                writeln('PENGHAPUSAN DATA PELANGGAN SUKSES');
                                garis;
                                writeln('Terima kasih sudah berlangganan pada kami :)');
                        end;
                Kembali;
                end;
        end;

        procedure Bayar(var T:TPelanggan);
        var
                k,i:integer;
                F : boolean;
                total : real;
                pilih : char;
        begin
                clrscr;
                writeln('BAYAR TAGIHAN');
                garis();
                CariData(T,i,F);
                if (F) then
                begin
                        garis;
                        writeln('Kupon yang anda miliki: ',T.TP[i].kupon);
                        write('Jumlah kupon yang ingin anda gunakan: ');
                        readln(k);
                        while (k > T.TP[i].kupon) do
                        begin
                                writeln('Jumlah kupon harus kurang atau sama dengan banyak kupon yang anda miliki');
                                write('Jumlah kupon yang ingin anda gunakan: ');
                                readln(k);
                        end;
                        T.TP[i].kupon := T.TP[i].kupon - k;
                        garis;
                        total := T.TP[i].Biaya - DiskonK(T,k,i) - DiskonT(T,i);
                        writeln('Biaya normal: ',T.TP[i].Biaya:0:0);
                        writeln('Diskon kupon: ',DiskonK(T,K,i):0:0);
                        writeln('Diskon tanggal: ',DiskonT(T,i):0:0);
                        writeln('Total pembayaran: ',total:0:0);
                        write('Apakah anda yakin untuk melakukan pembayaran? (Y/T): ');
                        readln(pilih);
                        ErrorHandling(pilih);
                        if (pilih = 'Y') or (pilih = 'y') then
                        begin
                                garis;
                                writeln('rekening ',T.TP[i].rekening,' sudah dipotong sebesar: ',total:0:0);
                                writeln('terima kasih sudah melakukan pembayaran');
                                T.TP[i].kupon := T.TP[i].kupon + 1;
                                T.TP[i].TanggalBayar := SenggangWaktu + 30;
                        end;
                kembali;
                end;
        end;

        procedure cek(var T:TPelanggan;var N:integer);
        var
                i,M : integer;
        begin
                M := 1;
                for i := 1 to N do
                begin

                        if (date > T.TP[M].TanggalBayar) then
                                DeleteT(M,N,T)
                        else
                                M := M + 1;
                end;
        end;

        procedure TampilSort (T:Tpelanggan);
        var
                i,j,min,y : integer;
                p : char;
                temp : DataPelanggan;
        begin
                repeat
                        clrscr;
                        y := 4;
                        writeln('LIST PELANGGAN');
                        Garis;
                        writeln('    Nama Lengkap        Nomor Telepon        Paket        Masa Aktif    ');
                        writeln('========================================================================');
                        for i := 1 to N do
                        begin
                                y := y + 1;
                                GotoXY(5,y);write(T.TP[i].Nama);
                                GotoXY(25,y);write(T.TP[i].Nomor);
                                GotoXY(46,y);write(T.TP[i].Paket);
                                GotoXY(59,y);write(DateTimeToStr(T.TP[i].TanggalBayar));
                                writeln;
                        end;
                        writeln('========================================================================');
                        writeln('MENU SORT');
                        Garis;
                        writeln('1. Nama Ascending');
                        writeln('2. Nama Descending');
                        writeln('3. Nomor Ascending');
                        writeln('4. Nomor Descending');
                        writeln('5. Paket Ascending');
                        writeln('6. Paket Descending');
                        writeln('7. Tanggal Ascending');
                        writeln('8. Tanggal Descending');
                        writeln('9. Kembali ke menu utama');
                        garis;
                        write('Pilih menu yang anda inginkan: ');
                        readln(p);
                        For i:=1 to N-1 do
                        begin
                                Min:=i;
                                For j:= i to n do
                                        case p of
                                        '1':If lowerCase(T.TP[j].Nama) <= lowerCase(T.TP[min].Nama) then
                                                Min:=j;
                                        '2':If lowerCase(T.TP[j].Nama) >= lowerCase(T.TP[min].Nama) then
                                                Min:=j;
                                        '3':if T.TP[j].nomor <= T.TP[min].nomor then
                                                Min:=j;
                                        '4':If T.TP[j].nomor >= T.TP[min].Nomor then
                                                Min:=j;
                                        '5':If T.TP[j].paket <= T.TP[min].Paket then
                                                Min:=j;
                                        '6':if T.TP[j].Paket >= T.TP[min].Paket then
                                                Min:=j;
                                        '7':If T.TP[j].TanggalBayar <= T.TP[min].TanggalBayar then
                                                Min:=j;
                                        '8':if T.TP[j].TanggalBayar >= T.TP[min].TanggalBayar then
                                                Min:=j;
                                        end;
                                Temp := T.TP[i];
                                T.TP[i] := T.TP[min];
                                T.TP[min] := temp;
                        end;
                until(p = '9');
        end;


//==============================================================================
//Program utama
begin
        //mengambil DataPelanggan dan BanyakDataPelanggan dari database jika ada
        if FileExists('DataPelanggan.DAT')Then
        begin
                Assign(ArsipPelanggan,'DataPelanggan.DAT');
                Reset(ArsipPelanggan);
                Read(ArsipPelanggan,TabPelanggan);
                close(ArsipPelanggan);
        end
        else
        begin
                Assign(ArsipPelanggan,'DataPelanggan.DAT');
                rewrite(ArsipPelanggan);
                write(ArsipPelanggan,TabPelanggan);
                close(ArsipPelanggan);
        end;
        if FileExists('BanyakDataPelanggan.DAT')Then
        begin
                Assign(ArsipBanyakData,'BanyakDataPelanggan.DAT');
                Reset(ArsipBanyakData);
                Read(ArsipBanyakData,N);
                close(ArsipBanyakData);
        end
        else
        begin
                Assign(ArsipBanyakData,'BanyakDataPelanggan.DAT');
                rewrite(ArsipBanyakData);
                N := 0;
                write(ArsipBanyakData,N);
                close(ArsipBanyakData);
        end;
        cek(TabPelanggan,N);
        // nomor pelanggan dimulai dari 1 lagi pada hari yang berbeda
        if (TabPelanggan.Tanggal <> date) then
                nomor := 0
        else
                nomor := n;
        DecodeDate(Date,YY,MM,DD);
        Ulang := False;
        clrscr;
        // Tampilan Awal
        writeln('SELAMAT DATANG DI APLIKASI TAGIHAN TELEPON SIMCITY');
        garis();
        repeat
                if (Ulang) then
                        clrscr;
                writeln('MENU AWAL');
                garis();
                writeln('1. Mulai berlangganan');
                writeln('2. Cek status');
                writeln('3. Bayar tagihan');
                writeln('4. Ganti paket');
                writeln('5. Berhenti berlangganan');
                writeln('6. List pelanggan');
                writeln('7. Keluar program');
                garis();
                write('Pilih menu yang anda inginkan: ');
                readln(pilih);
                Ulang := True;
                case pilih of
                        '1':InputData(TabPelanggan,N,nomor);
                        '2':CekStatus(TabPelanggan);
                        '3':Bayar(TabPelanggan);
                        '4':GantiPaket(TabPelanggan);
                        '5':Berhenti(TabPelanggan,N);
                        '6':TampilSort(TabPelanggan);
                end;
        until (pilih = '7');
        TabPelanggan.Tanggal := date;
        if (n <> 0) then
        begin
                //simpan DataPelanggan
                Assign(ArsipPelanggan,'DataPelanggan.DAT');
                rewrite(ArsipPelanggan);
                write(ArsipPelanggan,TabPelanggan);
                close(ArsipPelanggan);
                //simpan BanyakDataPelanggan
                Assign(ArsipBanyakData,'BanyakDataPelanggan.DAT');
                rewrite(ArsipBanyakData);
                write(ArsipBanyakData,N);
                close(ArsipBanyakData);
        end
        else
        begin
                //menghapus file database jika isinya kosong
                erase(ArsipBanyakData);
                erase(ArsipPelanggan);
        end;
end.
