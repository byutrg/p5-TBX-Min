package TBX::Min::TIG;
use strict;
use warnings;
use subs qw(part_of_speech status);
use Class::Tiny qw(
    term
    part_of_speech
    note
    customer
    status
);
use Carp;

# VERSION

# ABSTRACT: Store information from one TBX-Min C<tig> element
=head1 SYNOPSIS

    use TBX::Min::TIG;
    my $term_grp = TBX::Min::TIG->new(
        {term => 'bat signal', status => "preferred"});
    $term_grp->part_of_speech('noun');
    $term_grp->customer('GCPD');
    print $term_grp->term; # 'bat signal'

=head1 DESCRIPTION

This class represents a single term group contained in a TBX-Min file. A term
group contains a single term and information pertaining to it, such as part of
speech, a note, or the associated customer.

=cut

=head1 METHODS

=head2 C<new>

Creates a new C<TBX::Min::TIG> instance. Optionally you may pass in a hash
reference which is used to initialized the object. The fields of the hash
correspond to the names of the accessor methods listed below.

=head2 C<term>

Get or set the term text associated with this term group.

=head2 C<part_of_speech>

Get or set the part of speech associated with this term group.

=cut

sub part_of_speech {
    my ($self, $pos) = @_;
    if(defined $pos){
        _validate_pos($pos);
        $self->{part_of_speech} = $pos;
    }
    return $self->{part_of_speech};
}

=head2 C<note>

Get or set a note associated with this term group.

=head2 C<customer>

Get or set a customer associated with this term group.

=head2 C<status>

Get or set a status  associated with this term group.

=cut

sub status {
    my ($self, $status) = @_;
    if(defined $status){
        _validate_status($status);
        $self->{status} = $status;
    }
    return $self->{status};
}

=head1 SEE ALSO

L<TBX::Min>

=for Pod::Coverage BUILD

=cut
# above Pod::Coverage makes this not "naked" via Pod::Coverage::TrustPod
sub BUILD {
    my ($self, $args) = @_;
    if($args->{part_of_speech}){
        _validate_pos($args->{part_of_speech});
    }
    if($args->{status}){
        _validate_status($args->{status});
    }
    return;
}

my @allowed_pos = qw(noun properNoun verb adjective adverb other);
sub _validate_pos {
    my ($pos) = @_;
    if(!grep{$pos eq $_} @allowed_pos){
        croak "Illegal part of speech '$pos'";
    }
    return;
}

my @allowed_status = qw(admitted preferred notRecommended obsolete);
sub _validate_status {
    my ($pos) = @_;
    if(!grep{$pos eq $_} @allowed_status){
        croak "Illegal status '$pos'";
    }
    return;
}

1;
