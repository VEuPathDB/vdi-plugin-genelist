package DbiBatchExecutor;

use strict;
use DBI;

=pod

A class that makes it easy to call DBI's execute_array to do batch inserts or updates

batchSize:  how many rows will be included in the array that is submitted
commitSize: how many rows will be included in a commit

=cut

sub new {
  my ($class, $batchSize, $commitSize) = @_;
  my $self = {
	      batchSize=> $batchSize,
	      commitSize => $commitSize,
	      batchCount => 0,
	      commitCount => 0,
	      batchNum => 0
	     };

  bless($self, $class);
  return $self;
}

=pod

Call this method once per row that you want to insert or update.  It will periodically
call execute_array (based on batchSize) and commit (based on commitSize).

dbh: a connection handle, used to call commit
sth: a statement handle that has a prepared statement with one or more bind variables
finalBatch: a 0/1 flag.  1 means that this is the final batch.  do an execute and commit unconditionally
arrayRefs: one or more references to parallel arrays, one per bind variable.  these contain the growing
           set of rows to submit in the batch.  THESE ARRAYS ARE EMPTIED AUTOMATICALLY ON EXECUTE.

dpes not close the statement or connection.

sample calling code:

my $batchExecutor = new  DbiBatchExecutor(100, 1000);
my @udIdArray;
my @geneIdArray;
while(<F>) {
  chomp;
  push(@udIdArray, $userDatasetId);
  push(@geneIdArray, $_);
  $batchExecutor->periodicallyExecuteBatch($sth, 0, \@udIdArray, \@geneIdArray);
}
$batchExecutor->periodicallyExecuteBatch($sth, 1, \@udIdArray, \@geneIdArray);

=cut

sub periodicallyExecuteBatch {
  my ($self, $dbh, $sth, $finalBatch, @arrayRefs) = @_;

  $self->{batchCount}++;  # count of rows so far in this batch
  $self->{commitCount}++; # count of rows so far in this commit
  $self->{rowNum}++;      # total number of rows processed
  if ($self->{batchCount} == $self->{batchSize} || $finalBatch) {
    my $executeCount = $sth->execute_array({ ArrayTupleStatus => \my @tuple_status }, @arrayRefs);
    die "Failed executing row number $self->{rowNum}\n" unless $executeCount;
    $self->{batchCount} = 0;
    for my $arrayRef (@arrayRefs) {  # empty the provided arrays
      @$arrayRef = ();
    }
  }
  if ($self->{commitCount} == $self->{commitSize} || $finalBatch) {
    $dbh->commit();
    $self->{commitCount} = 0;
  }
}

1;
