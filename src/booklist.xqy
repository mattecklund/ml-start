import module namespace search-lib = "http://localhost:8080/modules/search-lib" at "modules/search-lib.xqy";
xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Book List</title>
  </head>
  <body>
    <ul>
      {
        for $book in fn:doc()
        return <li>{$book}</li>
      }
    </ul>
  </body>

</html>)