package sgf;

class Reader {
	
	public static inline function read( t : String ) : Node {
		return new Reader().parse( t );
	}
	
	public var src : String;
	public var root : Node;
	
	var index : Int;
	
	public function new() {}
	
	public function parse( t : String ) : Node {
		src = t;
		index = 0;
		root = new Node();
		parseTree( root );
		return root.children[0];
	}
	
	function parseTree( n : Node ) {
		while( index < src.length ) {
			var c = char();
			index++;
			switch( c ) {
			case ";" :
				n = parseNode( n );
			case '(' :
				parseTree( n );
			case ')':
				return;	
			}
		}
	}
	
	function parseNode( parent : Node ) {
		var n = new Node();
		if( parent == null ) root = n else parent.children.push( n );
		return ( n = parseProperties( n ) );
	}
	
	function parseProperties( node : Node ) : Node {
		var key = "";
		var values = new Array<String>();
		var i = 0;
		while( index < src.length ) {
			var c = char();
			if( c == ';' || c == '(' || c == ')' )
				break;
			if( char() == '[' ) {
				while( char() == '[' ) {
					index++;
					values[i] = "";
					while( char() != ']' && index < src.length ) {
						if( char() == '\\' ) {
							index++;
                            while( char() == "\r" || char() == "\n" ) {
                                index++;
                            }
						}
						values[i] += char();
                        index++;
					}
					i++;
					while( char() == ']' || char() == "\n" || char() == "\r" ) {
                        index++;
                    }
				}
				var c = Reflect.field( node, key );
				if( c != null ) {
					if( !Std.is( c, Array ) ) Reflect.setField( node, key, [Reflect.field(node,key)] );
					Reflect.setField( node, key, c.concat( values ) );
				} else {
					Reflect.setField( node, key, values.length > 1 ? cast values : cast values[0] );
				}
				key = "";
				values = [];
				i = 0;
				continue;
			}
			if( c != " " && c != "\n" && c != "\r" && c != "\t" ) {
                key += c;
            }
			index++;
		}
		return node;
	}

	inline function char() : String {
		return sgf.charAt( index );
	}
	
}
