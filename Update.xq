xquery version "1.0-ml";

declare option xdmp:output "method = html";

declare function local:saveBook(
        $title as xs:string,
        $author as xs:string?,
        $year as xs:string?,
        $price as xs:string?,
        $category as xs:string?
) {

(:Generates string based off of Host time and random concatinated:)
    (:Pulls the already existing id from a hidden input in the for:)
    let $id as xs:string := local:sanitizeInput(xdmp:get-request-field("idField"))
    (:Creates the new book element that will replace the old in db:)
    let $book as element(book) :=
        element book {
            attribute category { $category },
            attribute id { $id },
            element title { $title },
            element author { $author },
            element year { $year },
            element price { $price }
        }

    let $uri := '/bookstore/book-' || $id || '.xml'
    let $save := xdmp:document-insert($uri, $book)
     (:refresh to display correct values:)
    let $_ := xdmp:redirect-response("Update.xq")
    return
    (:***********WHY RETURN THIS?**********:)
        ()
};

declare function local:padString(
        $string as xs:string,
        $length as xs:integer,
        $padLeft as xs:boolean
) as xs:string {
    if (fn:string-length($string) = $length) then (
        $string
    ) else if (fn:string-length($string) < $length) then (
        if ($padLeft) then (
            local:padString(fn:concat("0", $string), $length, $padLeft)
        ) else (
            local:padString(fn:concat($string, "0"), $length, $padLeft)
        )
    ) else (
        fn:substring($string, 1, $length)
    )
};

declare function local:sanitizeInput($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","")
};

(:***************on post request Sanitize the parameters before sending them off to saveBook :)
    if (xdmp:get-request-method() eq "POST") then (

        if(xdmp:get-request-field("update") = "update") then (
            (:gets data from input fields HERE!:)
            let $title as xs:string? := local:sanitizeInput(xdmp:get-request-field("title"))
            let $_ := xdmp:log("Update Title is " || $title)
            let $author as xs:string? := local:sanitizeInput(xdmp:get-request-field("author"))
            let $year as xs:string? := local:sanitizeInput(xdmp:get-request-field("year"))
            let $price as xs:string? := local:sanitizeInput(xdmp:get-request-field("price"))
            let $category as xs:string? := local:sanitizeInput(xdmp:get-request-field("category"))
            return
            local:saveBook($title, $author, $year, $price, $category)
        ) else (
            let $_ := xdmp:log("trying to delete*******************************")
            let $id as xs:string := local:sanitizeInput(xdmp:get-request-field("idField"))
            let $uri := '/bookstore/book-' || $id || '.xml'
            let $x := xdmp:node-delete(doc($uri))
            let $ref := xdmp:redirect-response("Update.xq")
            return
                ""
            ))
    else(),


xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/style.css"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
</head>
<body>
    <a href="add-book.xqy" style="font-size=1.5ems; float-right">Add Books</a><br/>
    <a href="book-display.xqy" style="font-size:1.5ems" stlye=" float:right">Show Library</a>
    <h1 style="text-align: center">Update Books</h1>
    <table style="width:90%">

        {
            for $x in /book
            return
            <form action="update.xq" method="post">
                <tr>
                    <td style="width:25%">Title: <input type="text" name="title" value="{data($x/title)}" /> </td>
                    <td> <b> Author: </b><input type="text" name="author" value="{$x/author}"/> </td>
                    <td> <b> Year Published: </b><input type="text" name="year" value="{data($x/year)}"/></td>
                    <td> <b> Price: </b><input type="text" name="price" value="{$x/price}"/> </td>
                    <td>

                        <select style="margin:3%;" name="category" id="category">
                        <option/>
                        {
                        for $c in ('CHILDREN','FICTION','NON-FICTION')
                        return
                            element option {if ($c = $x/@category) then (attribute selected {"selected"}) else(),
                            attribute value {$c},$c}
                        }
                        </select><br/>
                    </td>
                    <input type="hidden" name="idField" value="{data($x/@id)}"/>
                    <td><input style='width:100%; margin:auto;' type="submit" name="update" value="update"/></td>
                    <td><input style='width:100%; margin:auto;' type="submit" name="delete" value="delete"/></td>
                </tr>
            </form>
        }
    </table>

</body>
</html>