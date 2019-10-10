page 60000 "BC Docker Container List"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BC Docker Container";
    SourceTableView = sorting(Tag) order(ascending);

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("BC Docker Container Name"; BCDockerContainerName)
                {
                    ApplicationArea = All;
                    TableRelation = "BC URL";
                    CaptionML = ENU = 'BC Docker Container Name';

                    trigger OnLookup(var _Text: Text): Boolean
                    var
                        _bcURL: Record "BC URL";
                        _bcURL_List: Page "BC URL List";
                    begin
                        _bcURL_List.SetTableView(_bcURL);
                        _bcURL_List.LookupMode := true;
                        if _bcURL_List.RunModal() = Action::LookupOK then begin
                            _bcURL_List.GetRecord(_bcURL);
                            if BCDockerContainerName <> _bcURL.Name then begin
                                BCDockerContainerName := _bcURL.Name;
                                FilterGroup(2);
                                SetRange(Name, BCDockerContainerName);
                                FilterGroup(0);
                                if FindFirst() then
                                    CurrPage.Update(false);
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        FilterGroup(2);
                        if BCDockerContainerName = '' then
                            SetRange(Name)
                        else
                            SetRange(Name, BCDockerContainerName);
                        FilterGroup(0);
                        if FindFirst() then
                            CurrPage.Update(false);
                    end;
                }
            }
            repeater(RepeaterName)
            {
                Editable = false;
                field(ID; ID)
                {
                    ApplicationArea = All;

                }
                field(Name; Name)
                {
                    ApplicationArea = All;

                }
                field(Tag; Tag)
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
            action(SetupBCDockerContainer)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Setup BC Docker Container';

                trigger OnAction()
                var
                    _bcURL_List: Page "BC URL List";
                begin
                    _bcURL_List.RunModal();
                end;
            }
            action(UpdateBCDockerContainer)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Update BC Docker Container';

                trigger OnAction()
                var
                    _bcURL: Record "BC URL";
                    _bcDCMgt: Codeunit "BC Docker Container Mgt.";
                begin
                    _bcURL.SetRange(Active, true);
                    if BCDockerContainerName <> '' then
                        _bcURL.SetRange(Name, BCDockerContainerName);

                    if _bcURL.FindSet(false, false) then
                        repeat
                            _bcDCMgt.CreateBCDC(_bcURL.URL);
                        until _bcURL.Next() = 0;

                    Message('Done!');
                end;
            }
        }
    }

    var
        BCDockerContainerName: Text[50];
}