# HTML Tree

The purpose of this is to create an HTML rendering of a file structure. 
The key is to be able to use a template for the HTML and therefore render the output however you like.

This was created to help render a simple file-browser with no dependencies so it could be used on a GitLab CI Pipeline. This will take a `./results` folder and build `index.html` files in each directory that allow for some simple navigation.

# Usage

## Flag `-H or --head`

A templating flag that allows you to define the header of the index.html files that are rendered out. Supply a file to insert before any of the listings. If this flag isn't supplied a default one will be used.

e.g.
```bash
./htmltree.sh --head header_template.html
./htmltree.sh -H header_template.html
```

## Flag `-F or --foot`

A templating flag that allows you to define the footer of the index.html files that are rendered out. Supply a file to insert after any of the listings. If this flag isn't supplied a default one will be used.

e.g.
```bash
./htmltree.sh --foot footer_template.html
./htmltree.sh -F footer_template.html
```

## Flag `-L or --li`

A templating flag that allows you to define how each entry in the listing will be rendered. Supply a template file. If this flag isn't supplied a default one will be used.
The html will create `<li>` lines in an unordered list by default.

e.g.
```bash
./htmltree.sh --li li_template.html
./htmltree.sh -L li_template.html
```

## `-G or --git-ignore`

Supplying this flag will look for a .gitignore file and hide files that match the patterns within it.

e.g.
```bash
./htmltree.sh --git-ignore
./htmltree.sh -G
```


## `-I or --hide-index`   

Exclude the index.html file from being rendered in the output list. If this is being used as a webpage, than by being on the page, you don't really need it to be listed.


## `--help`

Display the help for the program.

# Template Examples.

Below are some examples of the HTML templates you can use to customise your output.

## Variables
Within the template files theere are a number of variables available for the listings. Bleow is a list of all those variables:

```bash
- ${POSITIONAL_ARGS}    # All arguments on the cammand line.
- ${HTML_HEAD}          # Name of the Header Template File
- ${HTML_FOOT}          # Name of the Footer Template File
- ${HTML_LI}            # Name of the <li> Template File
- ${GIT_IGNORE}         # "yes" if --git-ignore flag is set.
- ${HIDE_INDEX}         # "yes" if --hide-index flag is set.
- ${TARGET_PATH}        # PATH given as an argument
- ${ABSOLUTE_PATH}      # PATH given as an argument converted to an absolute path.
- ${CURRENT_PATH}       # PATH of where command was run
- ${DEFAULT_HTML_HEAD}  # Default HTML header
- ${DEFAULT_HTML_FOOT}  # Default HTML footer
- ${DEFAULT_HTML_LI}    # Default HTML <li>
- ${FOLDERS}            # List of all folders found
- ${FOLDER}             # Current folder of file.
```

Only available for the `<li>` template:

```bash
- ${FILES}                  # Complete list of all files in folder.
- ${FILELINE}               # Output of the file listing with all parameters.
- ${file_permissions}       # permissions of the file. e.g. `drwxrw.rw.`
- ${file_subdirectories}    # number of subdirectories in the file. 0 if a normal file. more if a folder.
- ${file_owner}             # name of the owner of the file.
- ${file_group}             # name of the group of the file.
- ${file_size}              # size of the file in human-readable format.
- ${file_day}               # Numeric day the file was last updated.
- ${file_month}             # Numeric month the file was last updated.
- ${file_time}              # Time the file was last updated.
- ${file_name}              # Name of the file.
- ${file_path}              # Path of the file. Prefixed with './'
```

You can place these variables within your templates like so:

### Examples

Example `template_head.html`

```html
<html>
    <head>
    </head>
    <body>
        <h1>FILE LISTING: ${FOLDER}</h1>
        <ul>
```


Example `template_foot.html`

```html
        </ul>
        <footer>Stuff in here.</footer>
    </body>
</html>
```

Example `template_li.html`

```html
<li class=\"item\"><a href=\"${file_path}\">${file_name}</a></li>
```

Note that quotes need to be escaped to work.

You could then use all of these templates like so:

```bash
./htmltree.sh -F template_foot.html -H template_head.html -L template_li.html -I -G ./example
```

# Changelog

v1.0.0 - Initial Creation.