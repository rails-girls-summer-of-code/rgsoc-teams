shared_context "capture_system_io" do
  before :all do
    @old_stdout = $>
    $> = (@fake_logdest = StringIO.new)
  end

  after :all do
     $> = @old_stdout
  end
end
