package TBX::Min::NoteGrp;
use strict;
use warnings;
use Carp;

# VERSION

# ABSTRACT: Store information from one TBX-Min C<noteGrp> element
=head1 SYNOPSIS

    use TBX::Min::NoteGrp;
    use TBX::Min::Note;
    my $note_grp = TBX::Min::NoteGrp->new(
    my $note = TBX::Min::Note->new({noteKey => 'grammaticalGender', noteValue => 'male'});
    $note_grp->add_note($note);
    my $notes = $note_grp->notes;
    print $#$notes; # '1'

=head1 DESCRIPTION

This class represents a single note group contained in a TBX-Min file. A note
group contains a single noteValue and and optional noteKey.

=cut

=head1 METHODS

=head2 C<new>

Creates a new C<TBX::Min::NoteGrp> instance. Optionally you may pass in a hash
reference which is used to initialized the object. The fields of the hash
correspond to the names of the accessor methods listed below.

=cut
sub new {
    my ($class, $args) = @_;
    my $self;
    if((ref $args) eq 'HASH'){
        $self = $args;
    }else{
        $self = {};
    }
    $self->{notes} ||= [];
    return bless $self, $class;
}

=head2 C<notes>

Returns an array ref containing all of the C<TBX::Min::NoteGrp> objects
in this tig. The array ref is the same one used to store the objects
internally, so additions or removals from the array will be reflected in future
calls to this method.

=cut
sub notes { ## no critic(RequireArgUnpacking)
    my ($self) = @_;
    if (@_ > 1){
        croak 'extra argument found (notes is a getter only)';
    }
    return $self->{notes};
}

=head2 C<add_note>

Adds the input C<TBX::Min::Note> object to the list of language groups
contained by this object.

=cut
sub add_note {
    my ($self, $note) = @_;
    if( !$note || !$note->isa('TBX::Min::Note') ){
        croak 'argument to add_note should be a TBX::Min::Note';
    }
    push @{$self->{notes}}, $note;
    return;
}

=head1 SEE ALSO

L<TBX::Min>

=cut

1;
