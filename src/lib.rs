use rutie::{
    class, methods, AnyException, AnyObject, Array, Boolean, Class, Exception, Float, Hash,
    Integer, Object, RString, VM, Module,
};
use toml::Value;

class!(TromlExt);

methods!(
    TromlExt,
    _rtself,
    fn troml_ext_parse_toml_str(input: RString) -> Hash {
        let raw_toml = input.map_err(|e| VM::raise_ex(e)).unwrap();

        let parsed_toml = raw_toml
            .to_string()
            .parse::<Value>()
            .map_err(|e| {
                let msg = format!("{}", e);
                VM::raise_ex(AnyException::new("Troml::ExtParseError", Some(&msg)))
            })
            .unwrap();

        let mut hash = Hash::new();

        let _rutie_toml = toml_to_toml_value(parsed_toml, &mut hash);

        hash
    }
);

enum TomlValue {
    String(RString),
    Integer(Integer),
    Float(Float),
    Boolean(Boolean),
    Array(Array),
    Table(Hash),
    Datetime(AnyObject),
}

fn toml_to_toml_value(toml_value: Value, hash: &mut Hash) -> TomlValue {
    match toml_value {
        Value::String(s) => TomlValue::String(RString::new_utf8(&s)),
        Value::Integer(i) => TomlValue::Integer(Integer::new(i)),
        Value::Float(f) => TomlValue::Float(Float::new(f)),
        Value::Boolean(b) => TomlValue::Boolean(Boolean::new(b)),
        Value::Array(a) => {
            let mut rutie_arr = Array::new();
            for item in a.into_iter() {
                let rutie_val = toml_to_toml_value(item, hash);
                match rutie_val {
                    TomlValue::String(s) => rutie_arr.push(s),
                    TomlValue::Integer(i) => rutie_arr.push(i),
                    TomlValue::Float(f) => rutie_arr.push(f),
                    TomlValue::Boolean(b) => rutie_arr.push(b),
                    TomlValue::Array(a) => rutie_arr.push(a),
                    TomlValue::Table(t) => rutie_arr.push(t),
                    TomlValue::Datetime(d) => rutie_arr.push(d),
                };
            }
            TomlValue::Array(rutie_arr)
        }
        Value::Table(t) => {
            for (key, val) in t.into_iter() {
                let rutie_key = RString::new_utf8(&key);
                let mut nested_hash = Hash::new();
                let rutie_val = toml_to_toml_value(val, &mut nested_hash);

                match rutie_val {
                    TomlValue::String(s) => hash.store(rutie_key, s),
                    TomlValue::Integer(i) => hash.store(rutie_key, i),
                    TomlValue::Float(f) => hash.store(rutie_key, f),
                    TomlValue::Boolean(b) => hash.store(rutie_key, b),
                    TomlValue::Array(a) => hash.store(rutie_key, a),
                    TomlValue::Table(t) => hash.store(rutie_key, t),
                    TomlValue::Datetime(d) => hash.store(rutie_key, d),
                };
            }
            TomlValue::Table(hash.to_owned())
        }
        Value::Datetime(d) => {
            let args = [RString::new_utf8(&d.to_string()).to_any_object()];
            let ruby_datetime = unsafe { Class::from_existing("DateTime").send("iso8601", &args) };
            TomlValue::Datetime(ruby_datetime)
        }
    }
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_troml() {
    Module::from_existing("Troml").get_nested_class("TromlExt").define(|klass| {
        klass.def_self("parse", troml_ext_parse_toml_str);
    });
}

#[cfg(test)]
mod test {
    use rutie::{Hash, Array, RString, Integer as Int, VM, Object};
    use toml::Value;

    #[test]
    fn test_toml_parse() {
        let toml = "
simple='value'
[nested]
nested_key='nested_val'
nested_array=['first_element', 2]
";

        VM::init();
        let mut expected = Hash::new();
        let mut nested_hash = Hash::new();
        let mut nested_array = Array::new();

        nested_array.push(RString::new_utf8("first_element"));
        nested_array.push(Int::new(2));

        nested_hash.store(RString::new_utf8("nested_key"), RString::new_utf8("nested_val"));
        nested_hash.store(RString::new_utf8("nested_array"), nested_array);

        expected.store(RString::new_utf8("simple"), RString::new_utf8("value"));
        expected.store(RString::new_utf8("nested"), nested_hash);

        let mut actual = Hash::new();

        let toml_value = toml.parse::<Value>().unwrap();

        let _ = crate::toml_to_toml_value(toml_value, &mut actual);

        assert!(actual.equals(&expected), "expected {:?} to be equal to {:?}", actual, expected)
    }
}
