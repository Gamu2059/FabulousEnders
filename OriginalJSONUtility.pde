public final class JsonArray extends JsonUtility {
    private ArrayList<String> _elem;

    public JsonArray() {
        _elem = new ArrayList<String>();
    }

    public JsonArray(String path) {
        this();
        Load(path);
    }

    public boolean IsNull() {
        return _elem == null;
    }

    public boolean IsEmpty() {
        return _elem.isEmpty();
    }

    public String GetString(int index, String defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }

        if (!_IsProper(obj, stringToken, stringToken)) {
            return defaultValue;
        }
        return _RemoveEscape(_RemoveSideString(obj));
    }

    public int GetInt(int index, int defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return int(obj);
    }

    public float GetFloat(int index, float defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return float(obj);
    }

    public boolean GetBoolean(int index, boolean defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return boolean(obj);
    }

    public JsonObject GetJsonObject(int index) {
        if (IsNull()) {
            return null;
        }
        if (_elem.size()<=index) {
            return null;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return null;
        }
        JsonObject jsonObj = new JsonObject();
        jsonObj.Parse(obj);
        return jsonObj;
    }

    public JsonArray GetJsonArray(int index) {
        if (IsNull()) {
            return null;
        }

        if (_elem.size()<=index) {
            return null;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return null;
        }
        JsonArray jsonArray = new JsonArray();
        jsonArray.Parse(obj);
        return jsonArray;
    }

    /**
     各パラメーターの追加
     */
    public void AddString(String elem) {
        AddElement(stringToken + elem + stringToken);
    }

    public void AddInt(int elem) {
        AddElement(elem);
    }

    public void AddFloat(float elem) {
        AddElement(elem);
    }

    public void AddBoolean(boolean elem) {
        AddElement(elem);
    }

    public void AddJsonObject(JsonObject elem) {
        AddElement(elem);
    }

    public void AddJsonArray(JsonArray elem) {
        AddElement(elem);
    }

    private void AddElement(Object elem) {
        _elem.add(elem.toString());
    }

    /**
     各パラメーターの設定
     */
    public void SetString(int index, String elem) {
        SetElement(index, stringToken + elem + stringToken);
    }

    public void SetInt(int index, int elem) {
        SetElement(index, elem);
    }

    public void SetFloat(int index, float elem) {
        SetElement(index, elem);
    }

    public void SetBoolean(int index, boolean elem) {
        SetElement(index, elem);
    }

    public void SetJsonObject(int index, JsonObject elem) {
        SetElement(index, elem);
    }

    public void SetJsonArray(int index, JsonArray elem) {
        SetElement(index, elem);
    }

    private void SetElement(int index, Object elem) {
        int elemSize=Size();
        if (index < 0) {
            println("IndexOutOfBoundsException : " + index);
        } else {
            if (elemSize <= index) {
                for (int i=index-elemSize; 0<=i; i--) {
                    _elem.add(null);
                }
            }
            _elem.set(index, elem.toString());
        }
    }

    public void RemoveElement(int index) {
        _elem.remove(index);
    }

    public void ClearElements() {
        _elem.clear();
    }

    public int Size() {
        return _elem.size();
    }

    /**
     指定した文字列からデータを生成し、それを自身に格納する。
     */
    public void Parse(String jsonContents) {
        if (jsonContents == null) return;

        // 最初が '[' 最後が ']' でなければ生成しない
        if (!_IsProper(jsonContents, beginArrayToken, endArrayToken)) return;

        _elem = _Split(trim(_RemoveSideString(jsonContents)));
    }

    /**
     Json文字列を ',' で区切ってリストで返す。
     */
    protected ArrayList<String> _Split(String jsonContents) {
        ArrayList<String> jsonPair = new ArrayList<String>();
        boolean isLiteral = false;
        int arrayDepth = 0, objectDepth = 0;
        char temp;
        int lastSplitIdx = 0;

        if (jsonContents.length()!=0) {
            for (int i=0; i<jsonContents.length(); i++) {
                temp = jsonContents.charAt(i);

                if (temp == stringToken) {
                    if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
                        isLiteral = !isLiteral;
                    }
                }
                if (!isLiteral) {
                    if (temp == beginArrayToken) {
                        arrayDepth++;
                    } else if (temp == endArrayToken) {
                        arrayDepth--;
                    } else if (temp == beginObjectToken) {
                        objectDepth++;
                    } else if (temp == endObjectToken) {
                        objectDepth--;
                    }
                }

                if (temp == commaToken && !isLiteral && arrayDepth==0 && objectDepth == 0) {
                    String elem=trim(jsonContents.substring(lastSplitIdx, i));
                    if (elem.equals("null")) {
                        elem=null;
                    }
                    jsonPair.add(elem);
                    lastSplitIdx = i + 1;
                }
            }
            jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));
        }
        return jsonPair;
    }

    public String toString() {
        try {
            String elem;
            String[] product = new String[_elem.size()];
            for (int i=0; i<_elem.size(); i++) {
                elem = _elem.get(i);
                if (elem == null) {
                    continue;
                }
                product[i] = elem;
            }
            return beginArrayToken + newLineToken + join(product, ",\n") + newLineToken + endArrayToken;
        } 
        catch(Exception e) {
            println(e);
            println("JsonArray can not express oneself!");
            return null;
        }
    }
}
public final class JsonObject extends JsonUtility {
    private HashMap<String, String> _elem;
    private ArrayList<String> _names;

    public JsonObject() {
        _elem = new HashMap<String, String>();
        _names = new ArrayList<String>();
    }

    public JsonObject(String path) {
        this();
        Load(path);
    }

    public boolean IsNull() {
        return _elem == null;
    }

    public boolean IsEmpty() {
        return _elem.isEmpty();
    }

    public boolean HasKey(String name) {
        return _elem.containsKey(name);
    }

    public String GetString(String name, String defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }

        if (!_IsProper(obj, stringToken, stringToken)) {
            return defaultValue;
        }
        return _RemoveEscape(_RemoveSideString(obj));
    }

    public int GetInt(String name, int defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return int(obj);
    }

    public float GetFloat(String name, float defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return float(obj);
    }

    public boolean GetBoolean(String name, boolean defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return boolean(obj);
    }

    public JsonObject GetJsonObject(String name) {
        if (IsNull()) {
            return null;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return null;
        }
        JsonObject jsonObj = new JsonObject();
        jsonObj.Parse(obj);
        return jsonObj;
    }

    public JsonArray GetJsonArray(String name) {
        if (IsNull()) {
            return null;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return null;
        }
        JsonArray jsonArray = new JsonArray();
        jsonArray.Parse(obj);
        return jsonArray;
    }

    public void SetString(String name, String elem) {
        SetElement(name, stringToken + elem + stringToken);
    }

    public void SetInt(String name, int elem) {
        SetElement(name, elem);
    }

    public void SetFloat(String name, float elem) {
        SetElement(name, elem);
    }

    public void SetBoolean(String name, boolean elem) {
        SetElement(name, elem);
    }

    public void SetJsonObject(String name, JsonObject elem) {
        SetElement(name, elem);
    }

    public void SetJsonArray(String name, JsonArray elem) {
        SetElement(name, elem);
    }

    private void SetElement(String name, Object elem) {
        if (!HasKey(name)) {
            _names.add(name);
        }
        _elem.put(name, elem.toString());
    }

    /**
     指定した文字列からデータを生成し、それを自身に格納する。
     */
    public void Parse(String jsonContents) {
        if (jsonContents == null) return;

        // 最初が '{' 最後が '}' でなければ生成しない
        if (!_IsProper(jsonContents, beginObjectToken, endObjectToken)) {
            return;
        }

        _elem.clear();
        _names.clear();

        ArrayList<String> jsonPair = _Split(_RemoveSideString(jsonContents));
        String[] pair = new String[2];
        char temp;

        for (int i=0, end=jsonPair.size(); i<end; i++) {
            String jsonElem = jsonPair.get(i);

            for (int j=0, end2=jsonElem.length(); j<end2; j++) {
                temp = jsonElem.charAt(j);

                if (temp == colonToken) {
                    pair[0] = trim(jsonElem.substring(0, j));
                    pair[1] = trim(jsonElem.substring(j+1));


                    if (_IsProper(pair[0], stringToken, stringToken)) {
                        pair[0] = _RemoveSideString(pair[0]);
                    } else {
                        println("Inappropriate name. There in no \"");
                        continue;
                    }
                    if (pair[1].equals("null")) {
                        pair[1]=null;
                    }
                    SetElement(pair[0], pair[1]);
                    break;
                }
            }
        }
    }

    /**
     Json文字列を ',' で区切ってリストで返す。
     */
    protected ArrayList<String> _Split(String jsonContents) {
        ArrayList<String> jsonPair = new ArrayList<String>();
        boolean isLiteral = false;
        int arrayDepth=0, objectDepth=0;
        char temp;
        int lastSplitIdx = 0;
        for (int i=0; i<jsonContents.length(); i++) {
            temp = jsonContents.charAt(i);

            if (temp == stringToken) {
                if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
                    isLiteral = !isLiteral;
                }
            }
            if (!isLiteral) {
                if (temp == beginArrayToken) {
                    arrayDepth++;
                } else if (temp == endArrayToken) {
                    arrayDepth--;
                } else if (temp == beginObjectToken) {
                    objectDepth++;
                } else if (temp == endObjectToken) {
                    objectDepth--;
                }
            }

            if (temp == commaToken && !isLiteral && arrayDepth==0&&objectDepth==0) {
                jsonPair.add(trim(jsonContents.substring(lastSplitIdx, i)));
                lastSplitIdx = i + 1;
            }
        }
        jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));

        return jsonPair;
    }

    public String toString() {
        try {
            String name, elem;
            String[] product = new String[_names.size()];
            for (int i=0, end=_names.size(); i<end; i++) {
                name = _names.get(i);
                elem = _elem.get(name);
                if (elem == null) {
                    continue;
                }
                product[i] = stringToken + _InsertEscape(name) + stringToken + " : " + elem;
            }
            return beginObjectToken + newLineToken + join(product, ",\n") + newLineToken + endObjectToken;
        } 
        catch(Exception e) {
            println(e);
            println("JsonObject can not express oneself!");
            return null;
        }
    }
}
public abstract class JsonUtility {
    // pjsでなぜかchar型と直接的な比較を行うと失敗するので、このような冗長な定義をしています。
    public final char beginObjectToken = "{".charAt(0);
    public final char endObjectToken = "}".charAt(0);
    public final char beginArrayToken = "[".charAt(0);
    public final char endArrayToken = "]".charAt(0);
    public final char stringToken = "\"".charAt(0);
    public final char escapeToken = "\\".charAt(0);
    public final char commaToken = ",".charAt(0);
    public final char colonToken = ":".charAt(0);
    public final String newLineToken = "\n";

    public void Load(String path) {
        try {
            String[] jsonText = loadStrings(path);
            String json = join(trim(jsonText), "");
            Parse(json);
        } 
        catch (Exception e) {
            println(e);
        }
    }

    public void Save(String path) {
        try {
            saveStrings(path, new String[]{this.toString()});
        } 
        catch(Exception e) {
            println(e);
        }
    }

    public abstract void Parse(String content);
    protected abstract ArrayList<String> _Split(String content);

    protected boolean _IsProper(String content, char beginToken, char endToken) {
        if (content.length()==0) {
            return false;
        }
        return content.charAt(0) == beginToken && content.charAt(content.length() - 1) == endToken;
    }

    protected String _InsertEscape(String content) {
        if (content == null) return null;

        ArrayList<String> product = new ArrayList<String>();
        int lastSplitIndex = 0;
        char temp;
        for (int i=0; i<content.length(); i++) {
            temp = content.charAt(i);

            if (temp == escapeToken || temp == stringToken) {
                product.add(content.substring(lastSplitIndex, i) + escapeToken);
                lastSplitIndex = i;
            }
        }
        product.add(content.substring(lastSplitIndex, content.length()));
        String[] proArray = new String[product.size()];
        for (int i=0; i< proArray.length; i++) {
            proArray[i] = product.get(i);
        }

        return join(proArray, "");
    }

    protected String _RemoveEscape(String content) {
        if (content == null) return null;

        ArrayList<String> product = new ArrayList<String>();
        int lastSplitIndex = 0;
        char temp, temp2;
        for (int i=0; i<content.length(); i++) {
            temp = content.charAt(i);

            if (temp == escapeToken && i < content.length() - 1) {
                temp2 = content.charAt(i + 1);
                if (temp2 == escapeToken || temp2 == stringToken) {
                    product.add(content.substring(lastSplitIndex, i));
                    lastSplitIndex = i + 1;
                }
            }
        }
        product.add(content.substring(lastSplitIndex, content.length()));
        String[] proArray = new String[product.size()];
        for (int i=0; i< proArray.length; i++) {
            proArray[i] = product.get(i);
        }
        return join(proArray, "");
    }

    protected String _RemoveSideString(String content) {
        if (content == null) return null;
        return content.substring(1, content.length() - 1);
    }
}