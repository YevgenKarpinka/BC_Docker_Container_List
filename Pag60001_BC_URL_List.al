page 60001 "BC URL List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BC URL";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field(Active; Active)
                {
                    ApplicationArea = All;

                }
                field(ID; ID)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;

                }
                field(URL; URL)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}