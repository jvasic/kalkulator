unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }
  realniz = array [1..100] of real;
  charskup = set of char;
  charniz = array [1..100] of char;
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    procedure Button1Click(Sender: TObject);

  private
function  VrednostIzraza(s:string):real;  //glavna funkcija
  public

end;

var
  Form1: TForm1;
  pogresanUnos: boolean=false;
  deljenjenulom: boolean=false;

implementation

{$R *.lfm}

{ TForm1 }

function tform1.VrednostIzraza(s:string):real;
var i,j: integer;
    brojevi,racunski: charskup;
    niz1: realniz;
    znakniz: charniz;
    poslednji: integer=0;
    znakposlednji: integer=1;
    zag:integer=0;
begin
for i:=1 to 100 do begin znakniz[i]:=' '; niz1[i]:=0; end;
//I korak
brojevi := ['1','2','3','4','5','6','7','8','9','0'];
racunski := ['+','-','*','/',':'];
if s[1]='-' then znakniz[1]:='-' else znakniz[1]:='+';
i:=1;
while i<=length(s) do
begin
if s[i]=' ' then i:=i+1 else

if s[i] in brojevi then begin
  j:=i+1;
  while ((s[j] in brojevi) or (s[j] in ['.',','])) and (j<=length(s)) do
    j:=j+1;
  poslednji:=poslednji+1;                      // dodavanje u niz
  niz1[poslednji]:=strtofloat(copy(s,i,j-i));
  i:=j;
 end else

if s[i]='(' then begin
  zag:=1;
  j:=i+1;
  while (zag>0) and (j<=length(s)) do begin
    if s[j]='(' then zag:=zag+1;
    if s[j]=')' then zag:=zag-1;
    j:=j+1;
    end;
  if zag>0 then pogresanunos:=true;
  poslednji:=poslednji+1;
  niz1[poslednji]:=vrednostizraza(copy(s,i+1,j-i-2));
  i:=j;
  end;

if s[i] in racunski then begin
  if ((s[i+1] in racunski) or (i=length(s))) then begin
    pogresanUnos:=true;
    i:=i+1;
  end
  else begin
    znakposlednji:=znakposlednji+1;
    znakniz[znakposlednji]:=s[i];
    i:=i+1;
  end;
end;
end;
poslednji:=0;


 //II korak
 i:=1;
 while ((pos('*',znakniz)>0) or (pos('/',znakniz)>0)) do begin
if znakniz[i]='*' then begin
  niz1[i-1]:=niz1[i-1]*niz1[i];
  for j:=i to 99 do niz1[j]:=niz1[j+1];
  for j:=i to 99 do znakniz[j]:=znakniz[j+1];  end else
if znakniz[i]='/' then begin
   if niz1[i]=0 then begin
   deljenjenulom:=true;
   niz1[i]:=1;
   for j:=i to 99 do znakniz[j]:=znakniz[j+1];
   i:=i+1;
   end
   else begin
   niz1[i-1]:=niz1[i-1]/niz1[i];
   for j:=i to 99 do niz1[j]:=niz1[j+1];
  for j:=i to 99 do znakniz[j]:=znakniz[j+1];  end;
  end else i:=i+1;
end;
if znakniz[1]='+' then for i:=1 to 99 do znakniz[i]:=znakniz[i+1] else
if znakniz[1]='-' then begin for i:=1 to 99 do znakniz[i]:=znakniz[i+1]; niz1[1]:=-niz1[1]; end;
while ((pos('+',znakniz)>0) or (pos('-',znakniz)>0)) do begin
if (znakniz[1]='+') then begin
  niz1[1]:=niz1[1]+niz1[2];
  for i:=2 to 99 do niz1[i]:=niz1[i+1];
  for i:=1 to 99 do znakniz[i]:=znakniz[i+1]; end else
if znakniz[1]='-' then begin
  niz1[1]:=niz1[1]-niz1[2];
  for i:=2 to 99 do niz1[i]:=niz1[i+1];
  for i:=1 to 99 do znakniz[i]:=znakniz[i+1]; end;
end;

//III korak
vrednostizraza:=niz1[1];

end;


procedure TForm1.Button1Click(Sender: TObject);
var izraz: string;
    i,zag: integer;
    dozvoljeni:charskup;
    vr: real;
begin
pogresanunos:=false;
deljenjenulom:=false;
dozvoljeni := ['1','2','3','4','5','6','7','8','9','0','+','-','*','/','(',')','.',','];
izraz:=edit1.text;
for i:=1 to length(edit1.text) do //provera unosa
begin
zag:=0;
if ((izraz[i] in dozvoljeni) = false) then begin pogresanunos:=true; break; end;
if izraz[i]='(' then zag:=zag+1; if izraz[i]=')' then zag:=zag-1; end;
if zag>0 then pogresanunos:=true;
if pogresanunos=true then
showmessage('pogrešan unos, dozvoljeni karakteri su: 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, +, -, *, /, (, )')
else begin
  vr:=vrednostizraza(izraz);
  if pogresanunos=true then showmessage('pogrešan unos') else
  if deljenjenulom=true then
     edit2.text:='nedefinisano' else
  edit2.text:=floattostr(vr);
  end;
end;

//Jovan Vasić
end.
