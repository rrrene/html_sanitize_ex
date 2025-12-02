ExUnit.start()

defmodule Fixtures do
  def a_href_hacks do
    {"<a>text here</a>",
     [
       "<a href=\"javascript:alert('XSS');\">text here</a>",
       "<a href=javascript:alert('XSS')>text here</a>",
       "<a href=JaVaScRiPt:alert('XSS')>text here</a>",
       "<a href=javascript:alert(&quot;XSS&quot;)>text here</a>",
       "<a href=javascript:alert(String.fromCharCode(88,83,83))>text here</a>",
       "<a href=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>text here</a>",
       "<a href=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>text here</a>",
       "<a href=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>text here</a>",
       "<a href=\"jav\tascript:alert('XSS');\">text here</a>",
       "<a href=\"jav&#x09;ascript:alert('XSS');\">text here</a>",
       "<a href=\"jav&#x0A;ascript:alert('XSS');\">text here</a>",
       "<a href=\"jav&#x0D;ascript:alert('XSS');\">text here</a>",
       "<a href=\" &#14;  javascript:alert('XSS');\">text here</a>",
       "<a href=\"javascript&#x3a;alert('XSS');\">text here</a>",
       "<a href=`javascript:alert(\"RSnake says, 'XSS'\")`>text here</a>",
       "<a href=\"javascript&#x3a;alert('XSS');\">text here</a>",
       "<a href=\"javascript&#x003a;alert('XSS');\">text here</a>",
       "<a href=\"javascript&#x3A;alert('XSS');\">text here</a>",
       "<a href=\"javascript&#x003A;alert('XSS');\">text here</a>",
       "<a href=\"&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;\">text here</a>",
       "<a href=\"JAVASCRIPT:alert(\'foo\')\">text here</a>",
       "<a href=\"java<!-- -->script:alert(\'foo\')\">text here</a>",
       "<a href=\"awesome.html#this:stuff\">text here</a>",
       "<a href=\"java\0&#14;\t\r\n script:alert(\'foo\')\">text here</a>",
       "<a href=\"java&#0000001script:alert(\'foo\')\">text here</a>",
       "<a href=\"java&#0000000script:alert(\'foo\')\">text here</a>",
       ~s(<a href="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==">text here</a>)
     ]}
  end
end
