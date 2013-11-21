# Functions for validating TBX-Min files with RNG and XSD
package t::Schema::TestSchema;
use Test::Base -base;
use XML::LibXML;
use FindBin qw($Bin);
use Path::Tiny;
use Exporter::Easy (
    EXPORT => [qw( rng_validate xsd_validate )]
);

#../../schema/TBX-Min.rng
my $rng_path = path(path($Bin)->parent->parent,
    'schema', 'TBX-Min.rng');
my $rng = XML::LibXML::RelaxNG->new( location => $rng_path );

#../../schema/TBX-Min.xsd
my $xsd_path = path(path($Bin)->parent->parent,
    'schema', 'TBX-Min.xsd');
my $xsd = XML::LibXML::Schema->new( location => $xsd_path );

# Pass in a TBX string pointer; returns any errors or undef
sub rng_validate {
    my ($tbx_string) = @_;

    my $doc = XML::LibXML->load_xml(string => $tbx_string);
    my $error;

    if(!eval { $rng->validate( $doc ); 1;} ){
        $error = $@;
    }
    return $error;
}

sub xsd_validate {
    my ($tbx_string) = @_;

    my $doc = XML::LibXML->load_xml(string => $tbx_string);
    my $error;

    if(!eval { $xsd->validate( $doc ); 1;} ){
        $error = $@;
    }
    return $error;
}

1;
