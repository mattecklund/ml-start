xquery version "1.0-ml";

declare option xdmp:output "method = html";


declare function local:AlterBook($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","")
};

declare function local:sanitizeInput($chars as xs:string?) {
    fn:replace($chars,"[\]\[<>{}\\();%\+]","")
};

declare variable $q :=
    if (xdmp:get-request-method() eq "GET") then (
        let $cleanChar := local:sanitizeInput(xdmp:get-request-field("SearchInput"))
        let $returnedElem := cts:search(/book,cts:word-query($cleanChar))
        let $_  := xdmp:log($returnedElem)
        return
            $returnedElem
    )else();

xdmp:set-response-content-type("text/html"),
'<!DOCTYPE html>',
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/style.css"/>


</head>
<body>
    <a syle="text-size=1.5ems" href="add-book.xqy">Add to Library</a><br/>
    <a syle="text-size=1.5ems" href="Update.xq">Update Library</a>
    <h1 style="text-align: center">List Books</h1>
    <table  style="width:90%">
    {
        for $x in /book
        return
            <tr>
                <td> Title: {data($x/title)}</td>
                <td> <b> Author: </b> {$x/author}</td>
                <td> <b> Year Published: </b> {$x/year} </td>
                <td> <b> Price: </b> ${$x/price} </td>
                <td> <b> Category: </b> {data($x/@category)} </td>
            </tr>
    }
    </table>

    <table align="center" style="width:90%">
    {
        for $x in $q
        return
            <tr align="center">
                <td> Title: {data($x/title)}</td>
                <td> <b> Author: </b> {$x/author}</td>
                <td> <b> Year Published: </b> {$x/year} </td>
                <td> <b> Price: </b> {$x/price} </td>
                <td> <b> Category: </b> {$x/data(@category)} </td>
            </tr>
    }
    </table>


    <form method="GET" action="book-display.xqy">
    <p>

            <strong>Keyword Search:</strong>

        <div id='searchBox'>
            <input name="SearchInput"  type="text"/>
        </div>
            <input type="submit" value="Search" />

    </p>
    </form>

</body>
</html>
