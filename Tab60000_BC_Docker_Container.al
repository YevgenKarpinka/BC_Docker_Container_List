table 60000 "BC Docker Container"
{
    DataClassification = ToBeClassified;
    LookupPageId = "BC Docker Container List";

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

        }
        field(3; Tag; Text[50])
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
        key(SK; Name, Tag)
        {

        }
        key(SKTag; Tag)
        {

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