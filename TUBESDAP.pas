PROGRAM TUBESDAP;
uses crt,sysutils;

type smp = record
        nisn : longint;
        nama : string;
        ortu : string;
        kelamin : char;
        otak : string;
        ttl : string;
        nilai : real;
        jarak : real;
        nopdf : longint;
end;

type siswa = array[1..100] of smp;

type sukses = record
        nama : string;
        status : string;
        nopdf : longint;
        nilai : real;
end;

type lolos = array[1..100] of sukses;

VAR
        bocah : siswa;
        i : longint;
        anak : lolos;
        pilihan : char;
        arsipbocil : file of siswa;

        procedure garis();
          begin
            writeln('==============================================================================');
          end;

        procedure itungsementara(n : longint);

         begin
           if(bocah[n].jarak > 20) then
             bocah[n].otak:='Maaf Anda tidak bisa mendaftar disini'
           else
             begin
             if (bocah[n].nilai < 70) then
               bocah[n].otak:='Maaf Anda tidak bisa mendaftar disini'
             else
               bocah[n].otak:='Anda Sedang Dipertimbangkan :) ';
             end;
         end;


        procedure daftar();
        var
                w : string;
                i : longint;
          begin
            clrscr;
            writeln('Silahkan isi dengan data yang sebenar-benarnya');
            garis();
            write('Nama : ');
             begin
               i:=1;
               readln(w);
                 repeat
                   if (bocah[i].nopdf = 0) then
                       bocah[i].nama:=w;
                   i:= i+1;
                 until(bocah[(i-1)].nama = w);
                 i:=i-1;
             end;
            write('Masukan NISN : ');
              readln(bocah[i].nisn);
            write('Nama Orang Tua : ');
              readln(bocah[i].ortu);
            write('Jenis Kelamin : ');
              readln(bocah[i].kelamin);
            write('Tempat Tanggal Lahir : ');
              readln(bocah[i].ttl);
            write('Jarak rumah dengan Sekolah : ');
              readln(bocah[i].jarak);
            write('Nilai Akhir Pendidikan Sebelumnya : ');
              readln(bocah[i].nilai);
            bocah[i].nopdf:=bocah[i].nisn+i-76;
            writeln('Nomor Pendaftaran Anda Adalah : ',bocah[i].nopdf,' Simpan nomor ini baik-baik yaaa :v');
            itungsementara(i);
         end;

         procedure caridata();
         var
                w : longint;
                i : longint;
                n : longint;
                foundat : longint;
         begin
         clrscr;
           write('Masukan Nomor Pendaftaran anda : ');
           i:=0;
           foundat:=0;
           readln(w);
           repeat
             i:=i+1;
           until (bocah[i].nopdf = 0);
           for n:=1 to i do
             begin
             if (bocah[n].nopdf = w) then
               foundat:=n;
             end;
           if (foundat = 0) then
              writeln('Maaf data siswa tidak ditemukan di database :,(')
           else
             begin
              writeln('Nama                : ',bocah[foundat].nama);
              writeln('Orangtua            : ',bocah[foundat].ortu);
              writeln('NISN                : ',bocah[foundat].nisn);
              writeln('TTL                 : ',bocah[foundat].ttl);
              writeln('Jenis Kelamin       : ',bocah[foundat].kelamin);
              writeln('Jarak ke Sekolah    : ',bocah[foundat].jarak:0:2);
              writeln('Nilai Akhir SD      : ',bocah[foundat].nilai:0:2);
              writeln('Status Pendaftar    : ',bocah[foundat].otak);
            end;
         end;

         procedure clearsukses();
         var
           n,i : longint;
         begin
           n:=1;
           repeat
             n:=n+1;
           until(anak[n-1].nopdf = 0);
           n:=n-1;
           for i:=1 to n do
             begin
               anak[i].nama:=anak[n].nama;
               anak[i].nilai:=anak[n].nilai;
               anak[i].status:=anak[n].status;
               anak[i].nopdf:=anak[n].nopdf;
             end;
         end;

         procedure updatedata();
         var
                no : longint;
                i,foundat : longint;
                pil : string;
         begin
           clrscr;
           write('Masukan Nomor Pendaftaran Anda : ');
           readln(no);
           i:=1;
           foundat:=0;
           repeat
                if (bocah[i].nopdf = no) then
                  foundat:=i;
                i:=i+1;
           until ((bocah[(i-1)].nopdf = no) or (bocah[(i-1)].nopdf = 0));
           if (foundat = 0) then
              writeln('Maaf data siswa tidak ditemukan di database :,(')
           else
             begin
                writeln('Pilih data mana yang ingin anda perbarui');
                writeln('       1. Nama');
                writeln('       2. NISN');
                writeln('       3. Ortu');
                writeln('       4. Jenis Kelamin');
                writeln('       5. TTL');
                writeln('       6. Jarak');
                writeln('       7. NILAI');
                writeln('       8. Semua');
                write('Pilihan Anda : ');
                readln(pil);
                if (pil = '1') then
                  begin
                    write('Masukan Nama yang Baru : ');
                    readln(bocah[foundat].nama);
                  end
                else if (pil = '2') then
                  begin
                    write('Masukan NISN : ');
                    readln(bocah[foundat].nisn);
                  end
                else if (pil = '3') then
                  begin
                    write('Nama Orang Tua : ');
                    readln(bocah[foundat].ortu);
                  end
                else if (pil = '4') then
                  begin
                    write('Jenis Kelamin : ');
                    readln(bocah[foundat].kelamin);
                  end
                else if (pil = '5') then
                  begin
                    write('Tempat Tanggal Lahir : ');
                    readln(bocah[foundat].ttl);
                  end
                else if (pil = '6') then
                  begin
                    write('Jarak rumah dengan Sekolah : ');
                    readln(bocah[foundat].jarak);
                  end
                else if (pil = '7') then
                  begin
                    write('Nilai Akhir Pendidikan Sebelumnya : ');
                    readln(bocah[foundat].nilai);
                  end
                else if (pil = '8') then
                  begin
                    write('Masukan Nama yang Baru : ');
                    readln(bocah[foundat].nama);
                    write('Masukan NISN : ');
                    readln(bocah[foundat].nisn);
                    write('Nama Orang Tua : ');
                    readln(bocah[foundat].ortu);
                    write('Jenis Kelamin : ');
                    readln(bocah[foundat].kelamin);
                    write('Tempat Tanggal Lahir : ');
                    readln(bocah[foundat].ttl);
                    write('Jarak rumah dengan Sekolah : ');
                    readln(bocah[foundat].jarak);
                    write('Nilai Akhir Pendidikan Sebelumnya : ');
                    readln(bocah[foundat].nilai);
                  end
                else
                  begin
                    writeln('Ups sepertinya anda memasukan input yang salah, silahkan masukan kembali nomor pendaftaran');
                    write('Press Any Key To Continue');
                    readkey();
                    updatedata();
                  end;
                itungsementara(foundat);
                clearsukses();
             end;
         end;

         procedure deletesukses(nom : longint);
         var
           n,ketemu,i : longint;
         begin
         n:=1;
         ketemu:=0;
           repeat
             if (anak[n].nopdf = nom) then
                ketemu:=n;
             n:=n+1;
           until (anak[n-1].nopdf = 0);
           for i:=ketemu to (n-1) do
             begin
               anak[i].nama:=anak[i+1].nama;
               anak[i].status:=anak[i+1].status;
               anak[i].nilai:=anak[i+1].nilai;
               anak[i].nopdf:=anak[i+1].nopdf;
             end;
         end;


         procedure deletedata();
         var
           foundat,i,j : longint;
           no : longint;
         begin
         clrscr;
           write('Masukan Nomor Pendaftaran anda : ');
           readln(no);
            i:=1;
           foundat:=0;
           repeat
                if (bocah[i].nopdf = no) then
                  foundat:=i;
                i:=i+1;
           until (bocah[(i-1)].nopdf = 0);
           if (foundat = 0) then
             writeln('Data tidak ditemukan di database kami :v :v :v')
           else
             begin
               if ((bocah[foundat].nilai >= 70) and (bocah[foundat].jarak <= 20)) then
                 deletesukses(no);
               for j:=foundat to (i-1) do
               begin
                 bocah[j].nama:=bocah[j+1].nama;
                 bocah[j].nisn:=bocah[j+1].nisn;
                 bocah[j].ortu:=bocah[j+1].ortu;
                 bocah[j].ttl:=bocah[j+1].ttl;
                 bocah[j].kelamin:=bocah[j+1].kelamin;
                 bocah[j].jarak:=bocah[j+1].jarak;
                 bocah[j].nilai:=bocah[j+1].nilai;
                 bocah[j].otak:=bocah[j+1].otak;
                 bocah[j].nopdf:=bocah[j+1].nopdf;
               end;
             end;
         end;

         procedure cetak();
         var
           n,i,y : longint;

         begin
         clrscr;
         n:=0;
         y:=3;
           repeat
             n:=n+1;
           until(bocah[n].nopdf = 0);
           garis();
           writeln('     Nama               Nilai               Jarak            Status');
           garis();
           for i:=1 to (n-1) do
             begin
              y:=y+1;
              GoToXY(5,y);write(bocah[i].nama);
              GoToXY(25,y);write(bocah[i].nilai:0:1);
              GoToXY(46,y);write(bocah[i].jarak:0:1);
              GoToXY(59,y);write(bocah[i].otak);
              writeln;
             end;
         end;

         procedure transfer();
         var
           n,i,j : longint;
         begin
           n:=0;
           j:=0;
           repeat
             n:=n+1;
           until (bocah[n].nopdf = 0);
           for i:=1 to n do
           begin
             if ((bocah[i].nilai >= 70) and (bocah[i].jarak <= 20)) then
             begin
              j:=J+1;
              anak[j].status:='LULUS';
              anak[j].nama:=bocah[i].nama;
              anak[j].nopdf:=bocah[i].nopdf;
              anak[j].nilai:=bocah[i].nilai;
             end;
           end;
         end;

         procedure ngurutin();
         var
           i,n,j,max : longint;
           temp4 : longint;
           temp1 : real;
           temp2,temp3 : string;

         begin
         repeat
             n:=n+1;
         until (anak[n].nopdf = 0);
         for i:=1 to (n-2) do
          begin
           max:=i;
           for j:=i+1 to (n-1) do
           begin
             if (anak[max].nilai < anak[j].nilai) then
               max:=j;
           end;
           temp1:=anak[i].nilai;
           temp2:=anak[i].nama;
           temp3:=anak[i].status;
           temp4:=anak[i].nopdf;
           anak[i].nilai:=anak[max].nilai;
           anak[i].nama:=anak[max].nama;
           anak[i].status:=anak[max].status;
           anak[i].nopdf:=anak[max].nopdf;
           anak[max].nilai:=temp1;
           anak[max].nama:=temp2;
           anak[max].status:=temp3;
           anak[max].nopdf:=temp4;
          end;
         end;


         procedure hasilseleksi();
         var
          i,n,y : longint;
         begin
         n:=0;
         clrscr;
         garis();
         writeln('-------SELAMAT KEPADA CALON SISWA BARU SMPN 3 BOJONG KENYOT--------');
         garis();
         y:=3;
         repeat
           n:=n+1;
         until(anak[n].nilai = 0);
         {if (n > 31) then
            n:=31;}
           for i:=1 to (n-1) do
           begin
             y:=y+1;
             GoToXY(5,y);write(anak[i].nopdf);
             GoToXY(25,y);write(anak[i].nama);
             GoToXY(45,y);write(anak[i].nilai:0:2);
             GoToXY(55,y);write(anak[i].status);
             writeln;
           end;
           garis();
         end;

        procedure nanya();

        begin
          write('Apakah anda ingin kembali ke menu utama ? (y/t)');
          readln(pilihan);
          while (not((pilihan = 'y') or (pilihan = 't'))) do
            begin
              write('Sepertinya anda memberi input yang salah :( ');
              readln(pilihan);
            end;
        end;

        procedure menutama();
        var
          pil : string;
        begin
            clrscr;
            garis();
            writeln('SELAMAT DATANG DI SELEKSI ANAK CERDAS');
            garis();
            writeln('Silahkan memilih opsi yang tersedia');
            writeln('   1) Pendaftaran');
            writeln('   2) Update Data');
            writeln('   3) Hapus Data');
            writeln('   4) Cari Data');
            writeln('   5) Status Pendaftar');
            writeln('   6) Lihat Perkembangan');
            writeln('   7) Kelulusan');
            writeln('   8) Keluar Aplikasi');
            writeln('Silahkan Pilih sesuai dengan Opsi ya... :v:v:v');
            write('Pilihan Anda : ');
            readln(pil);
            if (pil = '1') then
             begin
              daftar();
              nanya();
              if (pilihan = 'y') then
                menutama();
              if (pilihan = 't') then
               begin
                clrscr;
                write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
               end;
             end;
            if (pil = '2') then
             begin
              updatedata();
              nanya();
              if (pilihan = 'y') then
                menutama();
              if (pilihan = 't') then
                begin
                 clrscr;
                 write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                end;
             end;
            if (pil = '3') then
             begin
              deletedata();
              nanya();
              if (pilihan = 'y') then
                menutama();
              if (pilihan = 't') then
                begin
                 clrscr;
                 write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                end;
             end;
            if (pil = '4') then
             begin
              caridata();
              nanya();
              if (pilihan = 'y') then
                 menutama();
              if (pilihan = 't') then
                 begin
                  clrscr;
                  write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                 end;
             end;
            if (pil = '5') then
             begin
              cetak();
              nanya();
              if (pilihan = 'y') then
                menutama();
              if (pilihan = 't') then
                begin
                 clrscr;
                 write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                end;
             end;
            if (pil = '6') then
             begin
              cetak();
              nanya();
              if (pilihan = 'y') then
                menutama();
              if (pilihan = 't') then
                begin
                 clrscr;
                 write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                end;
             end;
            if (pil = '7') then
              begin
                transfer();
                ngurutin();
                hasilseleksi();
                nanya();
                if (pilihan = 'y') then
                  menutama();
                if (pilihan = 't') then
                  begin
                    clrscr;
                    write('Silahkan klik ikon close (X) di pojok kanan atas :) ');
                  end;
              end;
            if (pil = '8') then
             begin
              clrscr;
              write('Silahkan mengklik Ikon close (X) di pojok kanan atas');
              pilihan:='t';
             end;
            if (not((pil='1') or (pil='2') or (pil='3') or (pil='4') or (pil='5') or (pil='6') or (pil='7') or (pil='8'))) then
               menutama();
        end;

BEGIN
        if FileExists('databocil.DAT') then
          begin
            assign(arsipbocil,'databocil.DAT');
            reset(arsipbocil);
            read(arsipbocil,bocah);
            close(arsipbocil);
          end
        else
          begin
            assign(arsipbocil,'databocil.DAT');
            rewrite(arsipbocil);
            write(arsipbocil,bocah);
            close(arsipbocil);
          end;
          menutama();
        assign(arsipbocil,'databocil.DAT');
        rewrite(arsipbocil);
        write(arsipbocil,bocah);
        close(arsipbocil);
END.








