xquery version "1.0-ml";

declare option xdmp:output "method = html";
(:
declare function local:loadBooks(){
        for $x in /bookstore/book
        return <h1>$x</h1>
   };
:)
xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
    <head>
        <title>Update Books</title>
    </head>
    <body>
        <form name="add-book" action="add-book.xqy" method="post">
            <fieldset>
                <legend>Add Book</legend>
                <label for="title">Title</label> <input type="text" id="title" name="title"/>
                <label for="author">Author</label> <input type="text" id="author" name="author"/>
                <label for="year">Year</label> <input type="text" id="year" name="year"/>
                <label for="price">Price</label> <input type="text" id="price" name="price"/>
                <label for="category">Category</label>
                <select name="category" id="category">
                    <option/>
                    {
                        for $c in ('CHILDREN','FICTION','NON-FICTION')
                        return
                            <option value="{$c}">{$c}</option>
                    }
                </select>
                <input type="submit" value="Update"/>

            </fieldset>
        </form>
        <ul>
            {
                for $x in /book
                return <li> <b> Title: </b> {data($x/title)} <b> Author: </b> {$x/author} <b> Year Published: </b> {$x/year}</li>
            }
        </ul>
        <select name="category" id="category" >
            <option/>
            {
                for $c in /book
                return
                    <option value="{$c}">{$c}</option>
            }
        </select>

    </body>
</html>


declare function local:findBook($q as xs:string)as elements{
return
};