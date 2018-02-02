xquery version "1.0-ml";

xdmp:set-response-content-type("text/html"),
('<!DOCTYPE html PUBLIC>',
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Book List</title>
    <link rel="stylesheet" href="styles/main.css"/>
  </head>
  <body>
    <div class="column left pushLeft">Left Column @ 15% width means that text will get wrapped around to the next line</div>
    <div class="column center pushLeft">
      {
        for $book in fn:doc()
        return
        <section>
          <h1>Book: </h1>
          <p>{$book}</p>
        </section>
      }
    </div>
    <div class="column right">Right Column @ auto overflow. Right Column @ auto overflow. Right Column @ auto overflow. Right Column @ auto overflow. Right Column @ auto overflow. Right Column @ auto overflow.</div>
  </body>

</html>)