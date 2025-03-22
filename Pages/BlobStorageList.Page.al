page 50100 "Blob Storage List"
{
    ApplicationArea = All;
    Caption = 'Blob Storage List';
    PageType = List;
    SourceTable = "Blob Storage";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file name.';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file extension.';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the file was uploaded.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                ApplicationArea = All;
                Caption = 'Upload File';
                Image = Import;
                ToolTip = 'Upload a file to blob storage.';

                trigger OnAction()
                var
                    BlobRec: Record "Blob Storage";
                    FileName: Text;
                    VarText: variant;
                    InStream: InStream;
                    OutStream: OutStream;
                begin
                    if UploadIntoStream('Select a file', '', '', VarText, InStream) then begin

                        FileName := VarText;
                        BlobRec.Init();
                        BlobRec."File Name" := CopyStr(FileName, 1, 250);
                        BlobRec."File Extension" := CopyStr(GetFileExtension(FileName), 1, MaxStrLen(BlobRec."File Extension"));
                        BlobRec."Created DateTime" := CurrentDateTime;

                        BlobRec."File Content".CreateOutStream(OutStream);
                        CopyStream(OutStream, InStream);

                        BlobRec.Insert(true);

                    end;
                end;

            }

            action(Download)
            {
                ApplicationArea = All;
                Caption = 'Download File';
                Image = Export;
                ToolTip = 'Download the selected file.';

                trigger OnAction()
                var
                    InStream: InStream;
                    FileName, FileExtension : Text;
                begin
                    Rec.CalcFields("File Content");
                    if not Rec."File Content".HasValue then
                        exit;

                    Rec."File Content".CreateInStream(InStream);

                    FileName := Rec."File Name";
                    FileExtension := Rec."File Extension";

                    if (FileExtension <> '') and (not FileName.EndsWith('.' + FileExtension)) then
                        FileName := FileName + '.' + FileExtension;

                    DownloadFromStream(InStream, '', '', '', FileName);
                end;
            }

            action(DownloadBase64)
            {
                ApplicationArea = All;
                Caption = 'Download File (Base64)';
                Image = Export;
                ToolTip = 'Download the selected file (Base64 content).';

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    Base64Convert: Codeunit "Base64 Convert";
                    InStream: InStream;
                    OutStream: OutStream;
                    FileName, FileExtension : Text;
                    Base64Text: Text;
                    BinaryOutStream: OutStream;
                begin
                    Rec.CalcFields("File Content");
                    if not Rec."File Content".HasValue then
                        exit;

                    //Sæt instream som indholdet skal hentes fra filen.
                    Rec."File Content".CreateInStream(InStream);

                    //Opret en outstream som indholdet skal kopieres til.
                    TempBlob.CreateOutStream(OutStream);

                    //Kopier indholdet fra Rec."File Content" til TempBlob
                    CopyStream(OutStream, InStream);

                    //Lav en forbindelse til TempBlob, hvor data kan læses fra
                    TempBlob.CreateInStream(InStream);

                    //Læs indholdet fra TempBlob som Base64 tekst
                    InStream.ReadText(Base64Text);

                    //Opret en outstream som indholdet skal kopieres til.
                    TempBlob.CreateOutStream(BinaryOutStream);

                    //Konverter Base64 til binær data
                    Base64Convert.FromBase64(Base64Text, BinaryOutStream);

                    FileName := Rec."File Name";
                    FileExtension := 'bmp';

                    if (FileExtension <> '') and (not FileName.EndsWith('.' + FileExtension)) then
                        FileName := FileName + '.' + 'bmp';


                    DownloadFromStream(InStream, '', '', '', FileName);
                end;
            }

        }

    }

    local procedure GetFileExtension(FileName: Text): Text
    var
        DotPosition: Integer;
    begin
        DotPosition := StrPos(FileName, '.');
        if DotPosition > 0 then
            exit(CopyStr(FileName, DotPosition + 1))
        else
            exit('');
    end;
}
