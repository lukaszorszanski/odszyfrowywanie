unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, Menus,
  ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinEdit1: TSpinEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  alfabet: array[0..255] of Byte;
  tabliczkaKodowa: array[0..255] of Byte;
  fileName: String;
  nrIteracji: Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Length(alfabet) - 1 do
      alfabet[i] := i;

  for i := 0 to Length(tabliczkaKodowa) - 1 do
      tabliczkaKodowa[i] := alfabet[i];

  nrIteracji := 0;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    fileName := OpenDialog1.Filename;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, j: Integer;
  datFile    : File of Char;
  chrContent : Char;
  tekstZPliku: String;
  dlugoscPliku: Integer;
  nazwaPliku: String;
  dlugoscAlfabetu: Integer;
begin
   AssignFile(datFile, fileName);
   Reset(datFile);
   tekstZPliku := '';
   dlugoscAlfabetu := Length(alfabet);

     while not eof(datFile)
       do begin
         read(datFile, chrContent);
         tekstZPliku := tekstZPliku + chrContent;
       end;

     CloseFile(datFile);

     dlugoscPliku := Length(tekstZPliku);

     Inc(nrIteracji);

     nazwaPliku := 'odszyfrowany_' +  IntToStr(nrIteracji) + '.txt';

     Assignfile(datFile, nazwaPliku);
     ReWrite(datFile);

     for i := 1 to dlugoscPliku do
      begin
        for j := 0 to dlugoscAlfabetu - 1 do
         begin
           if tabliczkaKodowa[j] = Ord(tekstZPliku[i]) then
             chrContent := Chr(alfabet[j]);
         end;
        Write(datFile, chrContent);
      end;

     CloseFile(datFile);

     Label2.Caption := IntToStr(nrIteracji);

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  index, i: Integer;
  znak: String;
begin
  index := SpinEdit1.Value;
  znak := Edit1.Text;

  for i := 0 to Length(tabliczkaKodowa) - 1 do
   begin
     if i = index then
        if RadioButton1.Checked then
           tabliczkaKodowa[i] := Ord(znak[1])
        else
           tabliczkaKodowa[i] := StrToInt(znak);
   end;

  for i := 0 to Length(tabliczkaKodowa) - 1 do
   begin
     if RadioButton1.Checked then
     begin
       if i = Ord(znak[1]) then
          tabliczkaKodowa[i] := index
     end
     else
     begin
       if i = StrToInt(znak) then
          tabliczkaKodowa[i] := index
     end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  datFile : File of Char;
  chrContent : Char;
  dlugoscAlfabetu: Integer;
begin
  Assignfile(datFile, 'tabliczkaKodowa.txt');
  ReWrite(datFile);
  dlugoscAlfabetu := Length(alfabet);

   for i := 0 to dlugoscAlfabetu - 1 do
    begin
      chrContent := Chr(tabliczkaKodowa[i]);
      Write(datFile, chrContent);
    end;

   CloseFile(datFile);

   Application.MessageBox('Zapisano tabliczkę kodową', 'Info');

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i, j: Integer;
  datFile    : File of Char;
  chrContent : Char;
  tekstZPliku: String;
  dlugoscPliku: Integer;
  nazwaPliku: String;
  dlugoscAlfabetu: Integer;
begin
  AssignFile(datFile, 'tabliczkaKodowa.txt');
  Reset(datFile);
  tekstZPliku := '';
  dlugoscAlfabetu := Length(alfabet);

   while not eof(datFile)
     do begin
       read(datFile, chrContent);
       tekstZPliku := tekstZPliku + chrContent;
     end;

   CloseFile(datFile);

   for i := 0 to dlugoscAlfabetu - 1 do
    tabliczkaKodowa[i] := Ord(tekstZPliku[i + 1]);

   Application.MessageBox('Wczytano tabliczkę kodową', 'Info');

end;

end.

