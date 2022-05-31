unit controller.root;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils,FileInfo, Horse;

type {TRoot}
   TRoot = class
     class procedure registry;
   end;

implementation

procedure onStatus(Req : THorseRequest; Res : THorseResponse; Next : TNextProc);
var
  LFileVersionInfo      : TFileVersionInfo;
  LVersionDate,LVersion : string;

begin
 LFileVersionInfo   := TFileVersionInfo.Create(nil);
 try
  LFileVersionInfo.ReadFileInfo;
  LVersion        := LFileVersionInfo.VersionStrings.Values['FileVersion'];
  LVersionDate    := {$I %DATE%} + ' ' + {$I %TIME%};

  Res.ContentType('text/html; charset=utf-8')
     .Send( '<h1> Api Pizzas </h1> <h2> Status -   Ativo </h2>'+
           '<p><b>Versão:   '        +   LVersion   + '</b></p>'+
           '<p>Compilação Data: ' + LVersionDate +'</p>')
     .status(200);
 finally
   FreeAndNil(LFileVersionInfo);
 end;
end;

{ TRoot }

class procedure TRoot.registry;
begin
  THorse.Get('', onStatus);
end;

end.

