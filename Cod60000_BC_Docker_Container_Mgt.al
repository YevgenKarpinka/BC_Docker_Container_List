codeunit 60000 "BC Docker Container Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure CreateBCDockerContainer(_Name: Text[50]; _Tag: Text[50])
    var
        BCDockerContainer: Record "BC Docker Container";
    begin
        with BCDockerContainer do begin
            SetCurrentKey(Name, Tag);
            SetRange(Name, _Name);
            SetRange(Tag, _Tag);
            if IsEmpty() then begin
                Init();
                Name := _Name;
                Tag := _Tag;
                Insert();
            end;
        end;
    end;

    procedure GetBCDockerContainer(_URL: Text[250]): Text
    var
        TempBlob: Record TempBlob;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Client: HttpClient;
        JSText: Text;
        JSObject: JsonObject;
        errMessage: Text;
        errExceptionMessage: Text;
        txtRequestMessageMethod: Label 'GET';
    begin
        RequestMessage.Method := txtRequestMessageMethod;
        RequestMessage.SetRequestUri(_URL);
        RequestMessage.GetHeaders(Headers);

        Client.Send(RequestMessage, ResponseMessage);
        If not ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(JSText);
            JSObject.ReadFrom(JSText);
            errMessage := GetJSToken(JSObject, 'Message').AsValue().AsText();
            errExceptionMessage := GetJSToken(JSObject, 'ExceptionMessage').AsValue().AsText();
            Error('Web service returned error:\\Status code: %1\Description: %2\Message: %3\Exception Message: %4',
                ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase(), errMessage, errExceptionMessage);
        end;

        ResponseMessage.Content().ReadAs(JSText);
        exit(JSText);
    end;

    procedure GetJSToken(_JSONObject: JsonObject; TokenKey: Text) _JSONToken: JsonToken
    begin
        if not _JSONObject.Get(TokenKey, _JSONToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure SelectJSToken(_JSONObject: JsonObject; Path: Text) _JSONToken: JsonToken
    begin
        if not _JSONObject.SelectToken(Path, _JSONToken) then
            Error('Could not find a token with path %1', Path);
    end;

    procedure CreateBCDC(_URL: Text[250]): Boolean
    var
        _jsonObject: JsonObject;
        _jsonArray: JsonArray;
        _jsonToken: JsonToken;
        _jsonText: Text;
        _Name: Text[50];
        _Tag: Text[50];
        Counter: Integer;
    begin
        _jsonText := GetBCDockerContainer(_URL);
        _jsonObject.ReadFrom(_jsonText);

        _Name := GetJSToken(_jsonObject, 'name').AsValue().AsText();
        _jsonArray := GetJSToken(_jsonObject, 'tags').AsArray();

        if GuiAllowed then
            Window.Open(StrSubstNo(txtWindowDialog, _Name) + txtWindowPercent);

        foreach _jsonToken in _jsonArray do begin
            _Tag := _jsonToken.AsValue().AsText();
            CreateBCDockerContainer(_Name, _Tag);

            if GuiAllowed then begin
                Counter += 1;
                Window.Update(1, 10000 * Counter div _jsonArray.Count);
            end;
        end;

        if GuiAllowed then
            Window.Close();
    end;

    var
        Window: Dialog;
        lblName: Label 'Name';
        lblTag: Label 'Tag';
        txtWindowDialog: TextConst ENU = 'Update BC URL\%1\';
        txtWindowPercent: TextConst ENU = '@1@@@@@@@@@@@@@@@@';
}