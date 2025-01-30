table 50100 "Blob Storage"
{
    Caption = 'Blob Storage';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
        }
        field(3; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            DataClassification = CustomerContent;
        }
        field(4; "File Content"; Blob)
        {
            Caption = 'File Content';
            DataClassification = CustomerContent;
        }
        field(5; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
