# Test the TBX-Min RelaxNG schema with good and bad files
package t::RNG::TestRNG;
use Test::Base -base;

1;

package t::RNG::TestRNG::Filter;
use Test::Base::Filter -base;
use XML::LibXML;
use FindBin qw($Bin);
use Path::Tiny;

#../../schema/TBX-Min.rng
my $rng_path = path(path($Bin)->parent->parent,
    'schema', 'TBX-Min.rng');
my $rng_doc = XML::LibXML->load_xml(location => $rng_path);
my $rng = XML::LibXML::RelaxNG->new( DOM => $rng_doc );

# Pass in a TBX string pointer; returns any errors or undef
sub validate {
    my ($self, $tbx_string) = @_;

    my $doc = XML::LibXML->load_xml(string => $tbx_string);
    my $error;

    if(!eval { $rng->validate( $doc ); 1;} ){
        $error = $@;
    }
    return $error;
}

1;
