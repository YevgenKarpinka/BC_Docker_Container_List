table 60001 "BC URL"
{
    DataClassification = ToBeClassified;
    LookupPageId = "BC URL List";

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = false;

        }
        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; URL; Text[250])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(4; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}