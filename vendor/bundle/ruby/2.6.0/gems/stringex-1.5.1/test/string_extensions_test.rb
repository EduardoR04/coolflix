# encoding: UTF-8
$KCODE = "U"

require "test/unit"

$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require File.join(File.expand_path(File.dirname(__FILE__)), "../init.rb")

class StringExtensionsTest < Test::Unit::TestCase
  def test_to_html
    require "rubygems"
    require "RedCloth"
    {
      "h1. A Solution" => "<h1>A Solution</h1>",
      "I hated wrapping textilize around a string.\n\nIt always felt dirty." =>
        "<p>I hated wrapping textilize around a string.</p>\n<p>It always felt dirty.</p>",
      "I think _this_ is awesome" => "<p>I think <em>this</em> is awesome</p>",
      "Um... _*really*_, man" => "<p>Um&#8230; <em><strong>really</strong></em>, man</p>"
    }.each do |plain, html|
      assert_equal html, plain.to_html
    end
  rescue LoadError
    puts "\n>> Could not load RedCloth. String#to_html was not tested.\n>> Please gem install RedCloth if you'd like to use this functionality."
  end

  def test_to_html_lite
    require "rubygems"
    require "RedCloth"
    {
      "I have no pee on me" => "I have no pee on me",
      "But I _do_ get Textile!" => "But I <em>do</em> get Textile!"
    }.each do |plain, html|
      assert_equal html, plain.to_html(:lite)
    end
  rescue LoadError
    puts "\n>> Could not load RedCloth. String#to_html (with :lite argument) was not tested.\n>> Please gem install RedCloth if you'd like to use this functionality."
  end

  def test_to_url
    {
      "<p>This has 100% too much    <em>formatting</em></p>" =>
        "this-has-100-percent-too-much-formatting",
      "Tea   &amp; crumpets &amp; <strong>cr&ecirc;pes</strong> for me!" =>
        "tea-and-crumpets-and-crepes-for-me",
      "The Suspense... Is... Killing Me" =>
        "the-suspense-dot-dot-dot-is-dot-dot-dot-killing-me",
      "How to use attr_accessible and attr_protected" =>
        "how-to-use-attr-accessible-and-attr-protected",
      "I'm just making sure there's nothing wrong with things!" =>
        "im-just-making-sure-theres-nothing-wrong-with-things",
      "foo = bar and bar=foo" =>
        "foo-equals-bar-and-bar-equals-foo",
      "Period.period" =>
        "period-dot-period",
      "Will???This Work?" =>
        "will-dot-dot-dot-this-work",
      "We check the D.N.A for matches" =>
        "we-check-the-dna-for-matches",
      "We check the D.N.A. for matches" =>
        "we-check-the-dna-for-matches",
      "Go to the Y.M.C.America" =>
        "go-to-the-ymcamerica",
      "He shops at J.C. Penney" =>
        "he-shops-at-jc-penney",
      "?? pound with cheese" =>
        "one-fourth-pound-with-cheese",
      "Will's Ferrel" =>
        "wills-ferrel",
      "??????????????" =>
        "kapital",
      "????????????" =>
        "ellada",
      "??????" =>
        "zhong-wen",
      "Paul C??zanne" =>
        "paul-cezanne",
      "21'17??51" =>
        "21-17-51",
      "ITCZ??1 (21??17??51.78???N / 89??35??28.18???O / 26-04-08 / 09:00 am)" =>
        "itcz-divide-1-21-degrees-17-51-dot-78-n-slash-89-degrees-35-28-dot-18-o-slash-26-04-08-slash-09-00-am",
      "???" =>
        "slash",
      "???????????????????????????????????????????????????????????????????????????" =>
        "si-hagarasuwoshi-beraremasu-sorehasi-woshang-tukemasen",
      "?? is a magical string" =>
        "at-is-a-magical-string",
      "either | or" =>
        "either-or",
      "La Maison d`Uliva" =>
        "la-maison-duliva",
      "??????????????????????????????????????????????????????????????????DJ???????????? - ??????????????????????????????" =>
        "katupeziterasuniri-xi-kahue-and-ba-dian-nei-nidjbusumo-singaporujing-ji-xin-wen",
      "AV??????????????????????????????????????????????????????????????????????????????" =>
        "avanpu-homusiatasisutemu-supikasisutemudeng",
      "?? ?????????????????? ?????? ??????????????" =>
        "u-lukomoria-dub-zielienyi"
    }.each do |html, plain|
      assert_equal plain, html.to_url
    end
  end

  def test_to_url_with_excludes
    assert_equal "So Fucking Special", "So Fucking Special".to_url(:exclude => "So Fucking Special")
  end

  def test_remove_formatting
    {
      "<p>This has 100% too much    <em>formatting</em></p>" =>
        "This has 100 percent too much formatting",
      "Tea   &amp; crumpets &amp; <strong>cr&ecirc;pes</strong> for me!" =>
        "Tea and crumpets and crepes for me"
    }.each do |html, plain|
      assert_equal plain, html.remove_formatting
    end
  end

  def test_strip_html_tags
    {
      "<h1><em>This</em> is good but <strong>that</strong> is better</h1>" =>
        "This is good but that is better",
      "<p>This is invalid XHTML but valid HTML, right?" =>
        "This is invalid XHTML but valid HTML, right?",
      "<p class='foo'>Everything goes!</p>" => "Everything goes!",
      "<ol>This is completely invalid and just plain wrong</p>" =>
        "This is completely invalid and just plain wrong"
    }.each do |html, plain|
      assert_equal plain, html.strip_html_tags
    end
  end

  def test_convert_accented_entities
    {
      "&aring;"  => "a",
      "&egrave;" => "e",
      "&icirc;"  => "i",
      "&Oslash;" => "O",
      "&uuml;"   => "u",
      "&Ntilde;" => "N",
      "&ccedil;" => "c"
    }.each do |entitied, plain|
      assert_equal plain, entitied.convert_accented_entities
    end
  end

  def test_convert_vulgar_fractions
    {
      "&frac14;" => "one fourth",
      "??" => "one fourth",
      "&#188;" => "one fourth",
      "&frac12;" => "half",
      "??" => "half",
      "&#189;" => "half",
      "&frac34;" => "three fourths",
      "??" => "three fourths",
      "&#190;" => "three fourths",
      "???" => "one third",
      "&#8531;" => "one third",
      "???" => "two thirds",
      "&#8532;" => "two thirds",
      "???" => "one fifth",
      "&#8533;" => "one fifth",
      "???" => "two fifths",
      "&#8534;" => "two fifths",
      "???" => "three fifths",
      "&#8535;" => "three fifths",
      "???" => "four fifths",
      "&#8536;" => "four fifths",
      "???" => "one sixth",
      "&#8537;" => "one sixth",
      "???" => "five sixths",
      "&#8538;" => "five sixths",
      "???" => "one eighth",
      "&#8539;" => "one eighth",
      "???" => "three eighths",
      "&#8540;" => "three eighths",
      "???" => "five eighths",
      "&#8541;" => "five eighths",
      "???" => "seven eighths",
      "&#8542;" => "seven eighths"
    }.each do |entitied, plain|
      assert_equal plain, entitied.convert_vulgar_fractions
    end
  end

  def test_convert_misc_entities
    {
      "America&#8482;" => "America(tm)",
      "Tea &amp; Sympathy" => "Tea and Sympathy",
      "To be continued&#8230;" => "To be continued...",
      "Foo&nbsp;Bar" => "Foo Bar",
      "100&#163;" => "100 pound",
      "35&deg;" => "35 degrees"
    }.each do |entitied, plain|
      assert_equal plain, entitied.convert_misc_entities
    end
  end

  def test_convert_smart_punctuation
    {
      "???smart quotes???" => '"smart quotes"',
      "???dumb quotes???" => "'dumb quotes'",
      "I love you, but???" => "I love you, but...",
    }.each do |smart, plain|
      assert_equal plain, smart.convert_smart_punctuation
    end
  end

  def test_convert_misc_characters
    {
      "Foo & bar make foobar" => "Foo and bar make foobar",
      "Breakdown #9" => "Breakdown number 9",
      "foo@bar.com" => "foo at bar dot com",
      "100% of yr love" => "100 percent of yr love",
      "Kisses are $3.25 each" => "Kisses are 3 dollars 25 cents each",
      "That CD is ??3.25 plus tax" => "That CD is 3 pounds 25 pence plus tax",
      "This CD is ??1000 instead" => "This CD is 1000 yen instead",
      "Food+Drink" => "Food plus Drink"
    }.each do |misc, plain|
      assert_equal plain, misc.convert_misc_characters
    end
  end

  def test_replace_whitespace
    {
      "this has     too much space" => "this has too much space",
      "\t\tThis is merely formatted with superfluous whitespace\n" =>
        " This is merely formatted with superfluous whitespace "
    }.each do |whitespaced, plain|
      assert_equal plain, whitespaced.replace_whitespace
    end

    assert_equal "now-with-more-hyphens", "now with more hyphens".replace_whitespace("-")
  end

  def test_collapse
    {
      "too      much space" => "too much space",
      "  at the beginning" => "at the beginning"
    }.each do |uncollapsed, plain|
      assert_equal plain, uncollapsed.collapse
    end

    assert_equal "now-with-hyphens", "----now---------with-hyphens--------".collapse("-")
  end

  def test_to_url_limit
    assert_equal "I am much too long".to_url(:limit => 13), "i-am-much-too"
  end
end
