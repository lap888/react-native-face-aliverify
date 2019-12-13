/*
 * @Author: top.brids 
 * @Date: 2019-12-11 23:40:02 
 * @Last Modified by: top.brids
 * @Last Modified time: 2019-12-12 16:32:50
 */


import React from 'react';
import { View, Text, TouchableOpacity, NativeModules, Platform, Alert } from 'react-native';
const ZIMFacade = NativeModules.ZIMFacade;
const App = () => {
  /**
	 * 调用刷脸SDK，返回身份验证情况
   * @param {*} url
	 * @param {*} certifyId 
	 */
  let verify = (url, certifyId) => {
    ZIMFacade.verify(url, certifyId, (response) => {
      console.log('verify=>', response);
      if (response) {
        // 处理业务逻辑
        console.log('处理业务逻辑...');
      } else {
        console.log('认证失败');
      }
    });
  }
  /**
  * 调用自己后台服务器接口 获取认证需要参数
  */
  let getZimid = (certName, certNo) => {
    ZIMFacade.getZimFace(certName, certNo,
      (response) => {
        console.log('getZimid=>', response);
        let responseJson = JSON.parse(response);
        if (responseJson.code == 200) {
          // 调用刷脸SDK
          verify(responseJson.data.certifyUrl, responseJson.data.certifyId);
        } else {
          console.log('===err===', response.message);
        }
      },
      (error) => {
        console.log(error);
      }
    );
  }
  return (
    <View style={{ justifyContent: 'center', alignItems: 'center', flex: 1, backgroundColor: 'lightgreen' }}>
      <Text style={{ color: '#fff', fontSize: 14 }}> 点击唤起阿里活体认证 </Text>
      <TouchableOpacity onPress={() => {
        Alert.alert(
          '认证提示',
          '您确定要进行活体认证吗?',
          [
            { text: '取消', onPress: () => console.log('Cancel Pressed'), style: 'cancel' },
            {
              text: '确定', onPress: () => {
                getZimid('李炎杰', '140429200204100014');
              }
            },
          ],
          { cancelable: false }
        )
      }}>
        <Text style={{ color: 'red', fontSize: 26 }}> 点击唤起阿里活体认证 </Text>
      </TouchableOpacity>
    </View>
  );
};


export default App;
