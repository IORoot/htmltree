
<div id="top"></div>

<div align="center">

<img src="https://svg-rewriter.sachinraja.workers.dev/?url=https%3A%2F%2Fcdn.jsdelivr.net%2Fnpm%2F%40mdi%2Fsvg%406.7.96%2Fsvg%2Fleaf.svg&fill=%2384CC16&width=200px&height=200px" style="width:200px;"/>

<h3 align="center">HTMLTree</h3>

<p align="center">
Create a static HTML rendering of a file structure. 
</p>    
</div>

##  1. <a name='TableofContents'></a> Table of Contents


* 1. [ Table of Contents](#TableofContents)
* 2. [About The Project](#AboutTheProject)
	* 2.1. [Built With](#BuiltWith)
	* 2.2. [Installation](#Installation)
* 3. [Usage](#Usage)
	* 3.1. [Flag `-H or --head`](#Flag-Hor--head)
	* 3.2. [Flag `-F or --foot`](#Flag-For--foot)
	* 3.3. [Flag `-LF or --li-file`](#Flag-LFor--li-file)
	* 3.4. [Flag `-LD or --li-directory`](#Flag-LDor--li-directory)
	* 3.5. [`-G or --git-ignore`](#-Gor--git-ignore)
	* 3.6. [`-I or --hide-index`](#-Ior--hide-index)
	* 3.7. [`--help`](#--help)
* 4. [Templating.](#Templating.)
	* 4.1. [Variables](#Variables)
* 5. [Examples](#Examples)
* 6. [Example templates](#Exampletemplates)
	* 6.1. [basic template](#basictemplate)
	* 6.2. [github template](#githubtemplate)
* 7. [Advanced CI usage.](#AdvancedCIusage.)
* 8. [Problems to fix](#Problemstofix)
* 9. [Contributing](#Contributing)
* 10. [License](#License)
* 11. [Contact](#Contact)
* 12. [Changelog](#Changelog)



##  2. <a name='AboutTheProject'></a>About The Project

![https://github.com/IORoot/htmltree/blob/master/templates/github/github_template.png?raw=true](https://github.com/IORoot/htmltree/blob/master/templates/github/github_template.png?raw=true)

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


###  3.1. <a name='Flag-Hor--head'></a>Flag `-H or --head`

A templating flag that allows you to define the header of the index.html files that are rendered out. Supply a file to insert before any of the listings. If this flag isn't supplied a default one will be used.

e.g.
```bash
./htmltree.sh --head header_template.html
./htmltree.sh -H header_template.html
```


###  3.2. <a name='Flag-For--foot'></a>Flag `-F or --foot`

A templating flag that allows you to define the footer of the index.html files that are rendered out. Supply a file to insert after any of the listings. If this flag isn't supplied a default one will be used.

e.g.
```bash
./htmltree.sh --foot footer_template.html
./htmltree.sh -F footer_template.html
```


###  3.3. <a name='Flag-LFor--li-file'></a>Flag `-LF or --li-file`

A templating flag that allows you to define how each file in the listing will be rendered. Supply a template file. If this flag isn't supplied a default one will be used.
The html will create `<li>` lines in an unordered list by default.

e.g.
```bash
./htmltree.sh --li-file li_file_template.html
./htmltree.sh -LF li_file_template.html
```


###  3.4. <a name='Flag-LDor--li-directory'></a>Flag `-LD or --li-directory`

A templating flag that allows you to define how each directory in the listing will be rendered. Supply a template file. If this flag isn't supplied a default one will be used.
The html will create `<li>` lines in an unordered list by default.

e.g.
```bash
./htmltree.sh --li-directory li_directory_template.html
./htmltree.sh -LD li_directory_template.html
```


###  3.5. <a name='-Gor--git-ignore'></a>`-G or --git-ignore`

Supplying this flag will look for a .gitignore file and hide files that match the patterns within it.

e.g.
```bash
./htmltree.sh --git-ignore
./htmltree.sh -G
```


###  3.6. <a name='-Ior--hide-index'></a>`-I or --hide-index`   

Exclude the index.html file from being rendered in the output list. If this is being used as a webpage, than by being on the page, you don't really need it to be listed.



###  3.7. <a name='--help'></a>`--help`

Display the help for the program.

##  4. <a name='Templating.'></a>Templating.

###  4.1. <a name='Variables'></a>Variables
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

##  5. <a name='Examples'></a>Examples

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

Example `template_li_file.html`

```html
<li class="item"><a href="{{file_path}}">{{file_name}}</a></li>
```


Example `template_li_directory.html`

```html
<li class="item"><a href="{{file_path}}"> FOLDER: {{file_name}}</a></li>
```


You could then use all of these templates like so:


```bash
./htmltree.sh -F template_foot.html -H template_head.html -LF template_li_file.html -LD template_li_directory -I -G ./example
```


##  6. <a name='Exampletemplates'></a>Example templates

There are two supplied templates:

###  6.1. <a name='basictemplate'></a>basic template

This contains a starting point on how to use the templates. Contains a file for each component. Get started by coping this template and customising it.

Usage:
```bash
./htmltree.sh -F ./templates/basic/template_foot.html -H ./templates/basic/template_head.html -LF ./templates/basic/template_li_file.html -LD ./templates/basic/template_li_directory -I -G ./example
```

###  6.2. <a name='githubtemplate'></a>github template

This template is stylised with TailwindCSS and is crafted to look like the github repository file-browser. Contains custom images, dynamic SVGs, File and folder icons as well as more file details.

Usage:
```bash
./htmltree.sh -F ./templates/github/template_foot.html -H ./templates/github/template_head.html -LF ./templates/github/template_li_file.html -LD ./templates/github/template_li_directory -I -G ./example
```

Screenshot:

![https://github.com/IORoot/htmltree/blob/master/templates/github/github_template.png?raw=true](https://github.com/IORoot/htmltree/blob/master/templates/github/github_template.png?raw=true)

##  7. <a name='AdvancedCIusage.'></a>Advanced CI usage.

Remember, If you are using this project within a CI pipeline, you could generate the template files to contain results of tests, etc... Those templates are then used to generate the HTML index files.


<p align="right">(<a href="#top">back to top</a>)</p>

##  8. <a name='Problemstofix'></a>Problems to fix

- The .gitignore doesn't work with folders. The patterning only works with files.

##  9. <a name='Contributing'></a>Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue.
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



##  10. <a name='License'></a>License

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



##  11. <a name='Contact'></a>Contact

Author Link: [https://github.com/IORoot](https://github.com/IORoot)

<p align="right">(<a href="#top">back to top</a>)</p>

##  12. <a name='Changelog'></a>Changelog

v1.0.0 - First version.
