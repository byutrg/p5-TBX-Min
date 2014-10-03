package TBX::Min::Note;
use strict;
use warnings;
use Class::Tiny qw(
    noteValue
	noteKey
);
use Carp;

# VERSION

# ABSTRACT: Store information from one TBX-Min C<tig> element
=head1 SYNOPSIS

    use TBX::Min::Note;
    my $note = TBX::Min::Note->new(
        {noteKey => "grammaticalGender", noteValue => 'male'});
    print $note->noteValue; # 'male'

=head1 DESCRIPTION

This class represents a single term group contained in a TBX-Min file. A term
group contains a single term and information pertaining to it, such as part of
speech, a note, or the associated customer.

=cut

=head1 METHODS

=head2 C<new>

Creates a new C<TBX::Min::Note> instance. Optionally you may pass in a hash
reference which is used to initialized the object. The fields of the hash
correspond to the names of the accessor methods listed below.

=head2 C<noteKey>

Get or set a noteKey associated with this note group.

=head2 C<noteValue>

Get or set a noteValue associated with this note group.

=head1 SEE ALSO

L<TBX::Min>

=for Pod::Coverage BUILD

=cut
# above Pod::Coverage makes this not "naked" via Pod::Coverage::TrustPod

my %valid = map +($_=>1), Class::Tiny->get_all_attributes_for(__PACKAGE__);
sub BUILD {
    my ($self, $args) = @_;

    if(my @invalids = grep !$valid{$_}, sort keys %$args){
        croak 'Invalid attributes for class: ' .
            join ' ', @invalids
    }

    return;
}

1;