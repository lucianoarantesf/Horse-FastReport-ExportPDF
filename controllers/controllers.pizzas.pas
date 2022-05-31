unit controllers.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  Horse,Horse.OctetStream,
  DataSet.Serialize,
  frxClass, frxDBSet, frxExportPDF;

type {TPizzas}
  TPizzas = class
    class procedure registry;
  end;

implementation

uses services.pizzas;

procedure getPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesPizzas     : TServicesPizzas;
   vId                 : String;
begin
  LServicesPizzas := TServicesPizzas.Create(nil);
  try
    try
       with LServicesPizzas do
       begin
         qryPizzas.Close;

          vId := '';
          if Req.Query.ContainsKey('id') then
          begin
           vId := Req.Query.Items['id'];
           qryPizzas.SQL.Strings[5] := 'AND ID = :ID';
           qryPizzas.ParamByName('ID').AsString := vId;
          end;

          qryPizzas.Open;

         Res.ContentType('application/json').Send(qryPizzas.ToJSONArrayString).status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPizzas);
  end;
end;

procedure onOpenPdfPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   lServicesPizzas     : TServicesPizzas;
   lReportStream       : TMemoryStream;
   lFile               : TFileReturn;
begin
  lServicesPizzas := TServicesPizzas.Create(nil);
  lReportStream   := TMemoryStream.Create;
  try
    try
       with lServicesPizzas do
       begin
        qryPizzas.Close;
        qryPizzas.Open;

        frxReport.EngineOptions.UseGlobalDataSetList := False;
        frxReport.EngineOptions.SilentMode           := True;
        frxReport.EngineOptions.EnableThreadSafe     := True;
        frxReport.EngineOptions.DestroyForms         := False;
        frxReport.PrintOptions.ShowDialog            := False;
        frxReport.ShowProgress                       := False;
        frxReport.PreviewOptions.AllowEdit           := False;
        frxReport.DataSets.Add(frxDBDataset);

        frxPDFExport.ShowDialog := False;
        frxPDFExport.ShowProgress := False;
        frxPDFExport.Stream       := lReportStream;

        frxReport.PrepareReport;
        frxReport.Export(frxPDFExport);

       end;

       lFile := TFileReturn.Create('cardapio-apiPizzas.pdf', lReportStream);
       Res.ContentType('application/octet-stream').Send<TFileReturn>(lFile).status(200);
    except
      on E:exception do
      begin
         Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
      end;
    end;

  finally
    FreeAndNil(lServicesPizzas);
  end;
end;


procedure onCreatePdfPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   lServicesPizzas     : TServicesPizzas;
   lReportStream       : TMemoryStream;
   lFile               : TFileReturn;

   frxReport           : TfrxReport;
   frxExportPDF        : TfrxPDFExport;
   frxDBSet            : TfrxDBDataset;
begin
  lServicesPizzas := TServicesPizzas.Create(nil);
  lReportStream   := TMemoryStream.Create;

  frxReport           := TfrxReport.Create(Nil);
  frxExportPDF        := TfrxPDFExport.Create(Nil);
  frxDBSet            := TfrxDBDataset.Create(Nil);
  try
    try

        lServicesPizzas.qryPizzas.Close;
        lServicesPizzas.qryPizzas.Open;

        frxDBSet.DataSet := lServicesPizzas.qryPizzas;

        frxReport.LoadFromFile(Format('%s%s\%s.fr3', [ExtractFilePath(ParamStr(0)), 'report','cardapio-pizzas']));
        frxReport.EngineOptions.UseGlobalDataSetList := False;
        frxReport.EngineOptions.SilentMode           := True;
        frxReport.EngineOptions.EnableThreadSafe     := True;
        frxReport.EngineOptions.DestroyForms         := False;
        frxReport.PrintOptions.ShowDialog            := False;
        frxReport.ShowProgress                       := False;
        frxReport.PreviewOptions.AllowEdit           := False;
        frxReport.DataSets.Add(frxDBSet);


        frxExportPDF.ShowDialog := False;
        frxExportPDF.ShowProgress := False;
        frxExportPDF.Stream       := lReportStream;

        frxReport.PrepareReport;
        frxReport.Export(frxExportPDF);




       lFile := TFileReturn.Create('cardapio-apiPizzas.pdf', lReportStream);
       Res.ContentType('application/octet-stream').Send<TFileReturn>(lFile).status(200);
    except
      on E:exception do
      begin
         Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
      end;
    end;

  finally
    FreeAndNil(lServicesPizzas);
    FreeAndNil(frxReport);
    FreeAndNil(frxExportPDF);
    FreeAndNil(frxDBSet);
  end;
end;

{ TPizzas }

class procedure TPizzas.registry;
begin
  THorse.Group
  .Prefix('pizzas')
  .Get('', getPizzas)
  .Get('/open/pdf', onOpenPdfPizzas)
  .Get('/create/pdf',onCreatePdfPizzas);
end;

end.

