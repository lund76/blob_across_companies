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
