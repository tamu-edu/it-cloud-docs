TODO:
- [x] Initialize mdbook default contents
- [x] Install addons
- [x] Add Aggie template customizations
- [x] Add basic infrastructure to SUMMARY.md
- [x] Reserve CNAME docs.cloud.tamu.edu
- [x] Configure GitHub Actions to build and deploy to GitHub Pages
- [ ] Configure GitHub Action for previewing changes
- [x] Add instructions for adding new section(s), editing content.


# Adding/Editing Content to this site

1. Create a new branch from `main` for your changes
2. Create/Edit the markdown files in the `src` directory 
3. **IMPORTANT** -- Add/Update links in the `SUMMARY.md` file to include your new content.
    * MdBook uses `SUMMARY.md` to build the sidebar of the site, and all content must be accessible from the sidebar.
    * The links in `SUMMARY.md` use relative pathing. `SUMMARY.md` is located in the root directory of `src`; the convention is `- [Page Title](./path/to/file.md)`
    * you can add as many subdirectories in `src` to logically group your pages as you like, as long as the path is correct. If a file isn't referenced correctly in `SUMMARY.md`, it will either 404 or display an empty page.
    * adding tabs to `- [Page Title](./path/to/file.md)` will create a nested list in the sidebar. For example:
        ```
        - [Page Title](./path/to/file.md)
            - [Nested Page Title](./path/to/file.md)
            - [Nested Page Title](./path/to/file.md)
            - [Nested Page Title](./path/to/file.md)
        ```
        will create a list in the sidebar that looks like this:
        ```
        1. Page Title       >
        ```
        that when clicked, will expand to show:
        ```
        1. Page Title           v
            1.1. Nested Page Title
            1.2. Nested Page Title
            1.3. Nested Page Title
        ```
        *note:* multiple levels of nesting are supported, make sure to use the correct number of tabs to nest your pages correctly.

        * Empty links can be used (i.e. `- [Page title]()`) to create a collapsible header for nested pages in the sidebar without a link to a page. This can be used to group pages logically without creating a page for the header.

4. Commit your changes
5. Push your changes to GitHub
6. Create a pull request to merge your changes into the `main` branch
    * This will trigger a GitHub Action to build and deploy a preview of your changes to GitHub Pages
7. Add a reviewer to your pull request to approve your changes
8. Once your changes are merged, GitHub Actions will build and deploy the site to GitHub Pages

# Markdown Syntax
A good reference for markdown syntax can be found [here](https://www.markdownguide.org/basic-syntax/)

## Adding Images
Images can be added to the `src` directory and referenced in markdown files using relative pathing. For example, if you add an image to `src/images/image.png`, you can reference it in a markdown file using `![alt text](./images/image.png)`

## Adding Links
Links can be added to markdown files using the following syntax: `[link text](https://www.example.com)`. Internal links are supported using relative pathing, i.e. `[link text](./path/to/file.md)` (if your file is in a different directory, make sure the relative path is correct, i.e. `../../path/to/file.md`). 

You can also link to a specific section of a page using the following syntax: `[link text](./path/to/file.md#section-title)` where `#section-title` is the Markdown header of the section you want to link to.

## Including other markdown files
You can include other markdown files in a markdown file using the following syntax: `{{#include path/to/file.md}}`. This is useful for including content that is shared across multiple pages, such as a disclaimer or warning.

## Adding Tables
Tables can be added to markdown files using the following syntax:
```
| Column 1 | Column 2 | Column 3 |
| --- | --- | --- |
| Row 1 | Row 1 | Row 1 |
```
* **IMPORTANT** -- formatting the content within cells of a table is not supported natively in markdown. If you need to format content within a table cell, you can use `HTML` tags to do so. For example:

    ```
    | Column 1 | Column 2 |
    | --- | --- |
    | Row 1 | <ul><li>Item 1</li><li>Item 2</li></ul> |
    | Row 2 | Item 1<br>Item 2 |
    ```
    will render as:
    | Column 1 | Column 2 |
    | --- | --- |
    | Row 1 | <ul><li>Item 1</li><li>Item 2</li></ul> |
    | Row 2 | Item 1<br>Item 2 |

    You **must** keep the `|` characters on the **same line** rather than breaking them up into multiple new lines in the `.md` document for the table to build correctly.

## Adding Code Blocks
Code blocks can be added to markdown files using the following syntax:
```
    ```language
    code
    ```
```
where `language` is the language of the code block. For example, to add a code block in `bash`, you would use:
```
    ```bash
    echo "Hello World"
    ```
```
code blocks are copiable, meaning you can house code snippets in markdown files that users can copy and paste into their own code.

## Mdbook-admonish
* This site uses the `mdbook-admonish` addon to add warning, note, and tip blocks to markdown files. The syntax for adding these blocks is as follows:
```
    ```admonish <type>
    content
    ```
``` 
where `<type>` is one of `warning`, `note`, or `tip`. For example:
```
    ```admonish warning
    This is a warning
    ```
```
* **Unlike normal codeblocks**, the content within admonish codeblocks will **keep** markdown formatting. For example:
```
    ```admonish warning
    This is a **warning**
    ```
```
will display warning as **warning**.

* Admonish blocks are collapsible by adding `collapsible=true` to the opening tag. For example:
```
    ```admonish warning collapsible=true
    This is a warning
    ```
```

* There is a custom style created for admonish blocks called `class=aggiecustom2` that is used to match the style of the rest of the site. You can also use `title=""` in the tag to generate a custom title to the collapsible block. For example:
```
    ```admonish collapsible=true class=aggiecustom2 title="Your custom title"
    content
    ```
```
This is useful for creating a collapsible block to house tables or other content that you want to keep formatted in markdown, but don't want to display by default.