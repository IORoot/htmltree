
<div id="top"></div>

<div align="center">

<img src="https://svg-rewriter.sachinraja.workers.dev/?url=https%3A%2F%2Fcdn.jsdelivr.net%2Fnpm%2F%40mdi%2Fsvg%406.7.96%2Fsvg%2Fleaf.svg&fill=%2384CC16&width=200px&height=200px" style="width:200px;"/>

<h3 align="center">HTMLTree</h3>

<p align="center">
Create a static HTML rendering of a file structure. 
</p>    
</div>

##  2. <a name='AboutTheProject'></a>About The Project

If you run CI pipelines, sometimes you have result files you wish to see. 
You could just download the artifacts and open it up locally, but there's also the functionality to push the results to the 'pages' facility within GitHub and GitLab. 
This renders any static HTML files you have and essentailly makes a website for you.

Therefore, if you had a static index.html file that listed all of your files, you'd have a rudimentary file-browser. 

This is where `htmltree` comes in. You run it against a folder (usually you CI `./results` directory) and it will create `index.html` files in each directory and sub-directory that all link together. 
Giving you the ability to navigate and browse the results.

The *Really* great part is that you use template files to change how those index files look. So you can theme the results however you like.

<p align="right">(<a href="#top">back to top</a>)</p>


###  2.1. <a name='BuiltWith'></a>Built With

This project was built with the following frameworks, technologies and software.

- [BASH](https://www.gnu.org/software/bash/)

<p align="right">(<a href="#top">back to top</a>)</p>


###  2.2. <a name='Installation'></a>Installation

These are the steps to get up and running.

1. Clone the repo in home directory.
    ```sh
    git clone https://github.com/IORoot/htmltree ~
    ```

<p align="right">(<a href="#top">back to top</a>)</p>


##  3. <a name='Usage'></a>Usage



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
- {{POSITIONAL_ARGS}}    # All arguments on the cammand line.
- {{HTML_HEAD}}          # Name of the Header Template File
- {{HTML_FOOT}}          # Name of the Footer Template File
- {{HTML_LI}}            # Name of the <li> Template File
- {{GIT_IGNORE}}         # "yes" if --git-ignore flag is set.
- {{HIDE_INDEX}}         # "yes" if --hide-index flag is set.
- {{TARGET_PATH}}        # PATH given as an argument
- {{ABSOLUTE_PATH}}      # PATH given as an argument converted to an absolute path.
- {{CURRENT_PATH}}       # PATH of where command was run
- {{DEFAULT_HTML_HEAD}}  # Default HTML header
- {{DEFAULT_HTML_FOOT}}  # Default HTML footer
- {{DEFAULT_HTML_LI}}    # Default HTML <li>
- {{FOLDERS}}            # List of all folders found
- {{FOLDER}}             # Current folder of file.
```

Only available for the `<li>` template:

```bash
- {{FILES}}                  # Complete list of all files in folder.
- {{FILELINE}}               # Output of the file listing with all parameters.
- {{file_permissions}}       # permissions of the file. e.g. `drwxrw.rw.`
- {{file_subdirectories}}    # number of subdirectories in the file. 0 if a normal file. more if a folder.
- {{file_owner}}             # name of the owner of the file.
- {{file_group}}             # name of the group of the file.
- {{file_size}}              # size of the file in human-readable format.
- {{file_day}}               # Numeric day the file was last updated.
- {{file_month}}             # Numeric month the file was last updated.
- {{file_time}}              # Time the file was last updated.
- {{file_name}}              # Name of the file.
- {{file_path}}              # Path of the file. Prefixed with './'
- {{file_type}}              # Either 'file' or 'folder'
- {{file_extension}}         # The extension of the filename.
```

You can place these variables within your templates like so:

### Examples

Example `template_head.html`

```html
<html>
    <head>
    </head>
    <body>
        <h1>FILE LISTING: {{FOLDER}}</h1>
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
<li class="item"><a href="{{file_path}}">{{file_name}}</a></li>
```

Note that quotes need to be escaped to work.

You could then use all of these templates like so:

```bash
./htmltree.sh -F template_foot.html -H template_head.html -L template_li.html -I -G ./example
```


<p align="right">(<a href="#top">back to top</a>)</p>


##  6. <a name='Contributing'></a>Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue.
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



##  7. <a name='License'></a>License

Distributed under the MIT License.

MIT License

Copyright (c) 2022 Andy Pearson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<p align="right">(<a href="#top">back to top</a>)</p>



##  8. <a name='Contact'></a>Contact

Author Link: [https://github.com/IORoot](https://github.com/IORoot)

<p align="right">(<a href="#top">back to top</a>)</p>

##  9. <a name='Changelog'></a>Changelog

v1.0.0 - First version.
