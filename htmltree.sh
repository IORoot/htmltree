#!/usr/bin/env bash

# export all variables by default.
# Used by the perl replacement script in substitute_variables() function
set -a

printhelp()
{
    printf "$0 flags [ PATH ]   
            
    -H  | --head              [ Header Template File ] 
    -F  | --foot              [ Footer Template File ] 
    -LF | --li-file           [ LI Template for files ] 
    -LD | --li-directory      [ LI Template for directories ] 

    -G | --git-ignore   Look for a .gitignore file and hide files that match pattern.
    -I | --hide-index   Exclude the index.html file from the output listings.

    --help\n"
}

# ┌─────────────────────────────────────┐
# │           Check Arguments           │
# └─────────────────────────────────────┘
if [ "$#" -eq 0 ]; then 
    printhelp
    exit 1
fi



POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in

        -H|--head)
            HTML_HEAD="$2"
            shift # past argument
            shift # past value
            ;;

        -F|--foot)
            HTML_FOOT="$2"
            shift # past argument
            shift # past value
            ;;

        -LF|--li-file)
            HTML_LI_FILE="$2"
            shift # past argument
            shift # past value
            ;;

        -LD|--li-directory)
            HTML_LI_DIRECTORY="$2"
            shift # past argument
            shift # past value
            ;;
        
        -G|--git-ignore)
            GIT_IGNORE="yes"
            shift # past argument
            ;;

        -I|--hide-index)
            HIDE_INDEX="yes"
            shift # past argument
            ;;

        --help)
            printhelp
            shift # past argument
            exit 0
            ;;
            
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;

        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            TARGET_PATH="$1"
            shift # past argument
            ;;

    esac
done

# restore positional parameters
set -- "${POSITIONAL_ARGS[@]}" 

# ┌─────────────────────────────────────┐
# │             VARIABLES               │
# └─────────────────────────────────────┘

ABSOLUTE_PATH="$(cd "$(dirname "$TARGET_PATH")"; pwd)/$(basename "$TARGET_PATH")"
CURRENT_PATH=$(pwd)
IGNORE=''


# ┌────────────────────────────────────┐
# │                                    │
# │   Substitute any {{moustaches}}    │
# │  for variables of the same name.   │
# │                                    │
# └────────────────────────────────────┘
substitute_variables()
{
    CONTENTS=$(perl -pe 's,{{(.*?)}},$ENV{$1},g' <<< $CONTENTS)
    
}

# ┌─────────────────────────────────────┐
# │           HTML TEMPLATES            │
# └─────────────────────────────────────┘
html_head()
{
    DEFAULT_HTML_HEAD="
<html>
    <head>
    </head>
    <body>
        <h1>FILE LISTING: {{FOLDER}}</h1>
        <ul>
"

    # If HTML_HEAD (-H) flag is set 
    if [ -z ${HTML_HEAD+x} ]; then 
        CONTENTS="${DEFAULT_HTML_HEAD}"
    else 
        CONTENTS=$(cat ${CURRENT_PATH}/${HTML_HEAD})

        # Replace % with %% so that printf will work.
        CONTENTS=$(echo "${CONTENTS}" | sed "s#%#%%#g")
    fi

    # Substitute any {{moustaches}}
    substitute_variables

    printf "${CONTENTS}\n" > index.html
    
}


html_li_directory()
{
    DEFAULT_HTML_LI_DIRECTORY="<li class=\"item\"><a href=\"{{file_path}}\">{{file_name}}</a></li>\n"

    if [ -z ${HTML_LI_DIRECTORY+x} ]; then 
        CONTENTS="${DEFAULT_HTML_LI_DIRECTORY}"
    else 
        CONTENTS=$(cat ${CURRENT_PATH}/${HTML_LI_DIRECTORY})

        # Replace % with %% so that printf will work.
        CONTENTS=$(echo "${CONTENTS}" | sed "s#%#%%#g")
    fi

    # Substitute any {{moustaches}}
    substitute_variables

    printf "${CONTENTS}\n" >> index.html

}


html_li_file()
{
    DEFAULT_HTML_LI_FILE="<li class=\"item\"><a href=\"{{file_path}}\">{{file_name}}</a></li>\n"

    if [ -z ${HTML_LI_FILE+x} ]; then 
        CONTENTS="${DEFAULT_HTML_LI_FILE}"
    else 
        CONTENTS=$(cat ${CURRENT_PATH}/${HTML_LI_FILE})

        # printf "${CONTENTS}\n"

        # Replace % with %% so that printf will work.
        CONTENTS=$(echo "${CONTENTS}" | sed "s#%#%%#g")
    fi

    # Substitute any {{moustaches}}
    substitute_variables

    
    printf "${CONTENTS}\n" >> index.html

}



html_foot()
{
    DEFAULT_HTML_FOOT="
        </ul>
    </body>
</html>
"

    if [ -z ${HTML_FOOT+x} ]; then 
        CONTENTS="${DEFAULT_HTML_FOOT}"
    else 
        CONTENTS=$(cat ${CURRENT_PATH}/${HTML_FOOT})

        # Replace % with %% so that printf will work.
        CONTENTS=$(echo "${CONTENTS}" | sed "s#%#%%#g")
    fi

    # Substitute any {{moustaches}}
    substitute_variables

    printf "${CONTENTS}\n" >> index.html

}


gitignore()
{

    # unset IGNORE

    cat ${CURRENT_PATH}/.gitignore | while IFS="" read -r IGNORE_RULE || [ -n "$IGNORE_RULE" ] 
    do
        if [[ $file_name == $IGNORE_RULE ]]; then
            echo "yes"
        fi
    done
    
}

# ┌─────────────────────────────────────┐
# │            REGEX ls -la             │
# └─────────────────────────────────────┘
regex_fileline()
{

    # Remove multiple spaces
    FILELINE=$(echo $1 | tr -s ' ')

    # Define REGEX
    regex="^(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)[[:space:]]+(.*)"

    if [[ $FILELINE =~ $regex ]]
    then
        file_permissions="${BASH_REMATCH[1]}"
        file_subdirectories="${BASH_REMATCH[2]}"
        file_owner="${BASH_REMATCH[3]}"
        file_group="${BASH_REMATCH[4]}"
        file_size="${BASH_REMATCH[5]}"
        file_day="${BASH_REMATCH[6]}"
        file_month="${BASH_REMATCH[7]}"
        file_time="${BASH_REMATCH[8]}"
        file_name="${BASH_REMATCH[9]}"
        file_path="./${BASH_REMATCH[9]}"
        file_extension="${file_name##*.}"
        file_type="file"

        # Skip the . and .. folders.
        if [[ "$file_name" == "." ]] || [[ "$file_name" == ".." ]] ; then
            file_type="directory"
            return
        fi

        # If the file is a directory, but not [.|..] output index.html on end.
        if [[ $file_permissions == d* ]]; then
            file_type="directory"
            file_path="${file_path}/index.html"
        fi
        

    else
        echo "$FILELINE doesn't match regex" >&2 # this could get noisy if there are a lot of non-matching files
    fi

}



# ┌─────────────────────────────────────┐
# │        List Files in Folder         │
# └─────────────────────────────────────┘
list_files()
{

    IFS=$'\n'
        # List  all files in folder.
        FILES=($(ls -lah . | grep -v "total"))
    unset IFS

    
    # Foreach file in the folder...
    for FILELINE in "${FILES[@]}"
    do

        # Get each component of the line 
        regex_fileline "${FILELINE}"

        # Skip the . folder.
        if [[ "$file_name" == "." ]]; then
            continue
        fi

        # Skip the root .. folder.
        if [[ "$file_name" == ".." ]] && [[ "${ABSOLUTE_PATH}" == "$(pwd)" ]]; then
            continue
        fi

        # Skip index.html if (HIDE_INDEX) is set.
        if [[ "$file_name" == "index.html" ]] && [[ "${HIDE_INDEX}" == "yes" ]]; then
            continue
        fi

        if [[ "${GIT_IGNORE}" == "yes" ]]; then
            IGNORE="$(gitignore)"
            if  [[ "${IGNORE}" == "yes" ]]; then
                continue
            fi
        fi

        if [[ "$file_type" == "directory" ]]; then
            html_li_directory
            continue
        fi

        # Output the <LI>
        html_li_file
    done

    unset FILES
}



# ┌─────────────────────────────────────┐
# │           Foreach folder            │
# └─────────────────────────────────────┘
run()
{

    IFS=$'\n'
    # Find all folders in target directory and remove the target path from each result.
    FOLDERS=($(find ${TARGET_PATH} -type d \( ! -name . \) | sed "s#${TARGET_PATH}#.#g"))
    unset IFS

    # Move into target directory.
    cd $TARGET_PATH

    for FOLDER in "${FOLDERS[@]}"
    do
        printf "FOLDER: %s\n" "${FOLDER}"

        # Move into FOLDER 
        cd $FOLDER

        # Output HTML head 
        html_head

        # List file and create index 
        list_files

        # Output HTML footer 
        html_foot

        cd $ABSOLUTE_PATH

    done

}

# Run script
run