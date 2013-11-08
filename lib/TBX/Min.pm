package TBX::Min;
use strict;
use warnings;
use XML::Twig;
use autodie;
use Path::Tiny;
use Carp;
use TBX::Min::ConceptEntry;
use TBX::Min::LangGroup;
use TBX::Min::TermGroup;
# VERSION

unless (caller){
	use Data::Dumper;
	print Dumper __PACKAGE__->new(@ARGV);

}

# ABSTRACT: Read, write and edit TBX-Min files
=head1 SYNOPSIS

	use TBX::Min;
	my $min = TBX::Min->new('/path/to/file.tbx');
	my $concepts = $min->concepts;

=head1 DESCRIPTION

TBX-Min is a minimal, DCT-style dialect of TBX. This module
allows you to read, write and edit the contents of TBX-Min
data.

=cut

=head1 METHODS

=head2 C<new>

Creates a new instance of TBX::Min. The single argument should be either a
string pointer containing the TBX-Min XML data or the name of the file
containing this data is required.

=cut

sub new {
	my ($class, $data) = @_;

	my $fh = _get_handle($data);

	# build a twig out of the input document
	my $twig = new XML::Twig(
		# pretty_print    => 'nice', #this seems to affect other created twigs, too
		# output_encoding => 'UTF-8',
		# do_not_chain_handlers => 1, #can be important when things get complicated
		keep_spaces		=> 0,
		TwigHandlers    => {
			# header attributes become attributes of the TBX::Min object
			title => \&_headerAtt,
			subjectField => \&_headerAtt,
			origin => \&_headerAtt,
			license => \&_headerAtt,
			directionality => \&_headerAtt,
			languages => \&_languages,

			# these become attributes of the current TBX::Min::TermGroup object
			term => sub {shift->{tbx_min_current_term_grp}->term($_->text)},
			partOfSpeech => sub {
				shift->{tbx_min_current_term_grp}->part_of_speech($_->text)},
			note => sub {shift->{tbx_min_current_term_grp}->note($_->text)},
			customer => sub {
				shift->{tbx_min_current_term_grp}->customer($_->text)},
			termStatus => sub {
				shift->{tbx_min_current_term_grp}->status($_->text)},
		},
		start_tag_handlers => {
			conceptEntry => \&_conceptStart,
			langGroup => \&_langStart,
			termGroup => \&_termGrpStart,
		}
	);

	# use handlers to process individual tags, then grab the result
	$twig->parse($fh);
	my $self = $twig->{tbx_min_att};
	$self->{concepts} = $twig->{tbx_min_concepts};
	bless $self, $class;
	return $self;
}

sub _get_handle {
	my ($data) = @_;
	my $fh;
	if((ref $data) eq 'SCALAR'){
		open $fh, '<', $data;
	}else{
		$fh = path($data)->filehandle('<');
	}
	return $fh;
}

=head2 C<title>

Get or set the document title.

=cut
sub title {
    my ($self, $title) = @_;
    if($title) {
        return $self->{title} = $title;
    }
    return $self->{title};
}

=head2 C<origin>

Get or set the document origin string (a note about or the title of the
document's origin).

=cut
sub origin {
    my ($self, $origin) = @_;
    if($origin) {
        return $self->{origin} = $origin;
    }
    return $self->{origin};
}

=head2 C<license>

Get or set the document license string.

=cut
sub license {
    my ($self, $license) = @_;
    if($license) {
        return $self->{license} = $license;
    }
    return $self->{license};
}

=head2 C<subject_field>

Get or set the document subject field string.

=cut
sub subject_field {
    my ($self, $subject_field) = @_;
    if($subject_field) {
        return $self->{subject_field} = $subject_field;
    }
    return $self->{subject_field};
}

=head2 C<directionality>

Get or set the document directionality string. This string represents
the direction of translation this document is designed for.

=cut
sub directionality {
    my ($self, $directionality) = @_;
    if($directionality) {
        return $self->{directionality} = $directionality;
    }
    return $self->{directionality};
}

=head2 C<source_lang>

Get or set the document source language (abbreviation) string.

=cut
sub source_lang {
    my ($self, $source_lang) = @_;
    if($source_lang) {
        return $self->{source_lang} = $source_lang;
    }
    return $self->{source_lang};
}

=head2 C<target_lang>

Get or set the document target language (abbreviation) string.

=cut
sub target_lang {
    my ($self, $target_lang) = @_;
    if($target_lang) {
        return $self->{target_lang} = $target_lang;
    }
    return $self->{target_lang};
}

=head2 C<concepts>

Returns an array ref containing the C<TBX::Min::ConceptEntry> objects contained
in the document.The array ref is the same one used to store the objects
internally, so additions or removals from the array will be reflected in future
calls to this method.

=cut
sub concepts {
    my ($self) = @_;
    if (@_ > 1){
        croak 'extra argument found (concepts is a getter only)';
    }
    return $self->{concepts};
}
######################
### XML TWIG HANDLERS
######################
# all of the twig handlers store state on the XML::Twig object. A bit kludgy,
# but it works.
sub _headerAtt{
	my ($twig, $_) = @_;
	${ $twig->{'tbx_min_att'} }{_decamel($_->name)} = $_->text;
	return 1;
}

# turn camelCase into camel_case
sub _decamel {
	my ($camel) = @_;
	$camel =~ s/([A-Z])/_\l$1/g;
	return $camel;
}

sub _languages{
	my ($twig, $_) = @_;
	if(my $source = $_->att('source')){
		${ $twig->{'tbx_min_att'} }{'source_lang'} = $source;
	}
	if(my $target = $_->att('target')){
		${ $twig->{'tbx_min_att'} }{'target_lang'} = $target;
	}
	return 1;
}

# add a new concept entry to the list of those found in this file
sub _conceptStart {
	my ($twig, $node) = @_;
	my $concept = TBX::Min::ConceptEntry->new();
	if($node->att('id')){
		$concept->id($node->att('id'));
	}else{
		carp 'found conceptEntry missing id attribute';
	}
	push @{ $twig->{tbx_min_concepts} }, $concept;
	return 1;
}

# Create a new LangGroup, add it to the current concept,
# and set it as the current LangGroup.
sub _langStart {
	my ($twig, $node) = @_;
	my $lang = TBX::Min::LangGroup->new();
	if($node->att('xml:lang')){
		$lang->code($node->att('xml:lang'));
	}else{
		carp 'found langGroup missing xml:lang attribute';
	}

	$twig->{tbx_min_concepts}->[-1]->add_lang_group($lang);
	$twig->{tbx_min_current_lang_grp} = $lang;
	return 1;
}

# Create a new termGroup, add it to the current langGroup,
# and set it as the current termGroup.
sub _termGrpStart {
	my ($twig, $node) = @_;
	my $term = TBX::Min::TermGroup->new();
	$twig->{tbx_min_current_lang_grp}->add_term_group($term);
	$twig->{tbx_min_current_term_grp} = $term;
	return 1;
}

1;

