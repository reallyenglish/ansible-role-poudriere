require "spec_helper"

context "after provision finishes" do
  describe server(:server1) do
    it "builds ports-mgmt/pkg" do
      result = current_server.ssh_exec "sudo poudriere bulk -p 10_3_re -j 10_3 -C ports-mgmt/pkg && echo SUCCESSFULL_BIULD"
      expect(result).to match(/SUCCESSFULL_BIULD/)
    end
  end
end
