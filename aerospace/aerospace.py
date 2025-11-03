import toml
import os

# If we have this in our template we replace it with the stuff from aerospace_common.toml
common_tag = "# AEROSPACE_COMMON"

# Files
aerospace_common_file = "aerospace_common.toml"
aerospace_template_file = "aerospace_template.toml"
aerospace_config_destination = "aerospace.toml"


# def insert_variables(toml_file, variables_config, common_config=None):
def insert_variables(toml_file, variables_config):
    aerospace_config = open(toml_file).read()
    # First parse variables to see if there are any that need replacement
    # Need to generate a new variable_config with the replacement
    variables_config2 = {}
    for k, v, in variables_config.items():
        value = v
        # Check if value is actually templated
        if isinstance(v, str):
            for k2, v2 in variables_config.items():
                str_key = "${" + k2 + "}"
                if str_key in value:
                    value = value.replace(str_key, v2)
        variables_config2[k] = value

    for k, v, in variables_config2.items():
        str_key = "${" + k + "}"
        match v:
            case bool():
                q_str_key = '"' + str_key + '"'
                if q_str_key in aerospace_config:
                    str_key = q_str_key
                v = str(v).lower()
            case int():
                q_str_key = '"' + str_key + '"'
                if q_str_key in aerospace_config:
                    str_key = q_str_key
            case float():
                q_str_key = '"' + str_key + '"'
                if q_str_key in aerospace_config:
                    str_key = q_str_key
            case str():
                if k.startswith("path_"):
                    v = str(os.path.expanduser(v))
            case _:
                print(v)
                raise ValueError("Unknown")
        aerospace_config = aerospace_config.replace(str_key, str(v))
    # Lastly if common_config is specified, update
    # if common_config:
    #     aerospace_config = aerospace_config.replace(common_tag, common_config)
    return aerospace_config



variables_config = None
with open("aerospace_variables.toml", "r") as file:
    variables_config = toml.load(file)

# common_config = insert_variables(aerospace_common_file, variables_config)
# aerospace_config = insert_variables(aerospace_template_file, variables_config, common_config)
aerospace_config = insert_variables(aerospace_template_file, variables_config)

# Write config
with open(aerospace_config_destination, "w") as f:
    f.write(aerospace_config)

print("aerospace.toml generated")