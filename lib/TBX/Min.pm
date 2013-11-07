package TBX::Min;
use XML::Rabbit::Root;
# VERSION

# ABSTRACT: Read/write/edit TBX-Min data
=head1 SYNOPSIS

	use TBX::Min;
	my $obj = TBX::Min->new();
	$obj->message();

=head1 DESCRIPTION

Description here

=cut

=head1 METHODS

=head2 C<new>

Creates a new instance of TBX::Min

=cut

=head2 C<other_subroutines>

PUT MORE SUBROUTINES HERE

=cut

has_xpath_value title      		=> './header/title';
has_xpath_value origin          => './header/origin';
has_xpath_value license     	=> './header/license';
has_xpath_value subject_field	=> './header/subjectField';
has_xpath_value directionality	=> './header/directionality';
has_xpath_value source_lang		=> './header/languages/@source';
has_xpath_value target_lang		=> './header/languages/@target';

has_xpath_object_list concepts  => './body/conceptEntry'
                            => 'TBX::Min::Concept';

finalize_class();

package TBX::Min::Concept;
use XML::Rabbit;

has_xpath_value id     					=> './@id';
has_xpath_object_list languages	=> './langGroup'
									=> 'TBX::Min::Concept::Language';

finalize_class();

package TBX::Min::Concept::Language;
use XML::Rabbit;

has_xpath_value code     		=> './@xml:lang';
has_xpath_object_list terms	=> './termGroup'
								=> 'TBX::Min::Concept::Language::Term';

finalize_class();

package TBX::Min::Concept::Language::Term;
use XML::Rabbit;

has_xpath_value text     		=> './term';
has_xpath_value part_of_speech     		=> './partOfSpeech';
has_xpath_value status     		=> './termStatus';
has_xpath_value customer     		=> './customer';
has_xpath_value note     		=> './note';

finalize_class();

1;
