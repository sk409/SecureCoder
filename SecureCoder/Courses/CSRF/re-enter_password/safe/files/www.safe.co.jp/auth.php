#[#<?php#]#
#[#    #]##[#function isExists($id, $password) {#]#
#[#        #]##[#$userId1 = "id1";#]#
#[#        #]##[#$userPassword1 = "pass1";#]#
#[#        #]##[#$userId2 = "id2";#]#
#[#        #]##[#$userPassword2 = "pass2";#]#
#[#        #]##[#$database = [#]#
#[#                 #]##[#$userId1=>$userPassword1,#]#
#[#                 #]##[#$userId2=>$userPassword2#]#
#[#        #]##[#];#]#
#[#        #]##[#return #]##[#array_key_exists($id, $database)#]##[# && #]##[#$database[$id] === $password#]##[#;#]#
#[#    #]##[#}#]#
#[#?>#]#